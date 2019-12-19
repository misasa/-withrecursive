module WithRecursive
  module ActiveRecordExtension
    module Associations

      extend ActiveSupport::Concern

      included do
        config = with_recursive_config
        belongs_to :parent, class_name: name, foreign_key: config.foreign_key
        has_many :children, -> { order config.order }, class_name: name, foreign_key: config.foreign_key
      end

      module ClassMethods
        attr_reader :with_recursive_config

        def roots
          config = with_recursive_config
          where(config.foreign_key => nil).order(config.order)
        end

        def root
          roots.first
        end

        def ancestors_by_id(id)
          find_with_recursive(ancestors_for_recursive(id), recursive_alias[:id].not_eq(id), :desc)
        end

        def ancestor_ids_by_id(id)
          find_ids_with_recursive(ancestor_ids_for_recursive(id), recursive_alias[:id].not_eq(id), :desc)
        end

        def descendants_by_id(id)
          find_with_recursive(descendants_for_recursive(id), recursive_alias[:id].not_eq(id), :asc)
        end

        def descendant_ids_by_id(id)
          find_ids_with_recursive(descendant_ids_for_recursive(id), recursive_alias[:id].not_eq(id), :asc)
        end

        def root_by_id(id)
          find_with_recursive(ancestors_for_recursive(id), recursive_alias[:parent_id].eq(nil), :desc).first
        end

        private

        def recursive_alias
          Arel::Table.new("r")
        end

        def recursive_alias_definition
          Arel::Nodes::SqlLiteral.new("#{recursive_alias.name}(#{(column_names + ["depth"]).join(",")})")
        end

        def recursive_alias_ids_definition
          Arel::Nodes::SqlLiteral.new("#{recursive_alias.name}(#{(["id", with_recursive_config.foreign_key] + ["depth"]).join(",")})")
        end

        def ancestors_for_recursive(id)
          sub_query_for_recursive(id, recursive_alias[with_recursive_config.foreign_key].eq(arel_table[:id]))
        end

        def ancestor_ids_for_recursive(id)
          sub_query_ids_for_recursive(id, recursive_alias[with_recursive_config.foreign_key].eq(arel_table[:id]))
        end

        def descendants_for_recursive(id)
          sub_query_for_recursive(id, recursive_alias[:id].eq(arel_table[with_recursive_config.foreign_key]))
        end

        def descendant_ids_for_recursive(id)
          sub_query_ids_for_recursive(id, recursive_alias[:id].eq(arel_table[with_recursive_config.foreign_key]))
        end

        def sub_query_for_recursive(id, on_clause)
          select(column_names + [:"1"]).where(id: id).union(:all, sub_query_for_union(on_clause))
        end

        def sub_query_ids_for_recursive(id, on_clause)
          select(["id", with_recursive_config.foreign_key] + [:"1"]).where(id: id).union(:all, sub_query_ids_for_union(on_clause))
        end        

        def sub_query_for_union(on_clause)
          select(column_names.map { |c| arel_table[c] } + [recursive_alias[:depth] + 1]).build_arel.join(recursive_alias).on(on_clause)
        end

        def sub_query_ids_for_union(on_clause)
          select(["id", with_recursive_config.foreign_key].map { |c| arel_table[c] } + [recursive_alias[:depth] + 1]).build_arel.join(recursive_alias).on(on_clause)
        end

        def with_recursive_query(sub_query, where_clause, depth_order_direction)
          query = recursive_alias.project("*")
          query = query.where(where_clause) if where_clause
          query = query.order("depth #{depth_order_direction}")
          query = query.order(with_recursive_config.order) if with_recursive_config.order
          query.with(:recursive, Arel::Nodes::As.new(recursive_alias_definition, sub_query))
        end

        def with_recursive_query_ids(sub_query, where_clause, depth_order_direction)
          query = recursive_alias.project("id")
          query = query.where(where_clause) if where_clause
          query = query.order("depth #{depth_order_direction}")
          query = query.order(with_recursive_config.order) if with_recursive_config.order
          query.with(:recursive, Arel::Nodes::As.new(recursive_alias_ids_definition, sub_query))
        end

        def find_with_recursive(query, where_clause, depth_order_direction)
          find_by_sql(with_recursive_query(query, where_clause, depth_order_direction))
        end

        def find_ids_with_recursive(query, where_clause, depth_order_direction)
          sql = with_recursive_query_ids(query, where_clause, depth_order_direction)
          ActiveRecord::Base.connection.select_all(sanitize_sql(sql)).rows.flatten.map(&:to_i)
        end        
      end

      def ancestors
        self.class.ancestors_by_id(id)
      end

      def ancestor_ids
        self.class.ancestor_ids_by_id(id)
      end

      def descendants
        self.class.descendants_by_id(id)
      end

      def descendant_ids
        self.class.descendant_ids_by_id(id)
      end

      def root
        self.class.root_by_id(id)
      end

      def siblings
        self_and_siblings.where.not(id: id)
      end

      def self_and_siblings
        parent ? parent.children : self.class.roots
      end

      def families
        r = root
        r.depth = 1
        [r] + r.descendants
      end

      def family_ids
        r = root
        r.depth = 1
        [r.id] + r.descendant_ids
      end      
    end
  end
end

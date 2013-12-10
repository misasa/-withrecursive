require "active_record"
require "with_recursive/version"
require "with_recursive/configure"
require "with_recursive/active_record/associations"

module WithRecursive
  def with_recursive(foreign_key: :parent_id, order: nil)
    @with_recursive_config = Configure.new(foreign_key: foreign_key, order: order)
    include ActiveRecord::Associations
  end
end

ActiveRecord::Base.extend WithRecursive

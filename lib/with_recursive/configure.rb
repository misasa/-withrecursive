module WithRecursive
  class Configure
    attr_reader :foreign_key, :order

    def initialize(foreign_key: :parent_id, order: nil)
      @foreign_key = foreign_key
      @order = order
    end
  end
end

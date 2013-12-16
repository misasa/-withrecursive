class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.integer :parent_id
      t.integer :code
    end
  end
end

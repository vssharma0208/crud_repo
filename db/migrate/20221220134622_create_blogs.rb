class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :name
      t.text :content
      t.boolean :is_active, default: true

      t.timestamps
    end
    add_index :blogs, :is_active
  end
end

class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.boolean :adult
      t.integer :chapters_count
      t.decimal :rating, limit: 3, precision: 3, scale: 2

      t.timestamps
    end
  end
end

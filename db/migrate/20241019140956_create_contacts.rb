class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.string :email, null: false

      t.timestamps
    end
  end
end

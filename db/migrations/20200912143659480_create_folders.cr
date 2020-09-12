class CreateFolders < Jennifer::Migration::Base
  def up
    create_table :folders do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :folders if table_exists? :folders
  end
end

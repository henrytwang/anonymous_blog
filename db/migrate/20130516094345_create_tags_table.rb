class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string    :name
      t.integer   :authenticated_user_id, :default => nil
      t.timestamps
    end
  end
end

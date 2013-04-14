class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :article

      t.timestamps
    end
    add_index :discussions, :article_id
  end
end

class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.string :pubip
      t.string :pvtip

      t.timestamps null: false
    end
  end
end

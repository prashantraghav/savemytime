class ChangeResponseBodyInEcourt < ActiveRecord::Migration
  def up
    change_column :ecourts, :response_body, :longtext
  end

  def down
    change_column :ecourts, :response_body, :text
  end
end

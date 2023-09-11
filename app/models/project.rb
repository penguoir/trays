class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  enum status: { active: 0, inactive: 1 }
end

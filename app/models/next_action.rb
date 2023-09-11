class NextAction < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_many :next_action_projects
  has_many :projects, through: :next_action_projects

  scope :incomplete, -> { where(completed_at: nil) }
  scope :complete, -> { where.not(completed_at: nil) }

  def complete?
    completed_at.present?
  end

  def incomplete?
    !complete?
  end
end

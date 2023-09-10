class InboxItem < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  validate :processed_at_is_set_if_processed
  validates :content, presence: true

  def pinned?
    user.pinned_inbox_item == self
  end

  private

  def processed_at_is_set_if_processed
    if processed? && processed_at.nil?
      errors.add(:processed_at, "must be set if processed")
    end
  end
end

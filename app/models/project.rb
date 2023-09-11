class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  has_many :next_action_projects
  has_many :next_actions, through: :next_action_projects

  validate :cannot_be_incubating_and_waiting_for
  validate :waiting_for_must_match_waiting_since

  scope :incubating, -> { where("incubating_until > ?", DateTime.current) }
  scope :waiting_for, -> { where("waiting_for is not null") }
  scope :active, -> { where.not(id: incubating.ids + waiting_for.ids) }
  scope :missing_next_action, -> { where.missing(:next_actions) }

  after_update_commit :unincubate_later, if: :saved_change_to_incubating_until?

  def unincubate_later
    UnincubateProjectJob.set(wait_until: incubating_until).perform_later(self)
  end

  def incubating?
    incubating_until&.future? || false
  end

  def active?
    !incubating? && !waiting_for?
  end

  def waiting_for?
    waiting_for.present?
  end

  def incubating_until=(value)
    if value.is_a?(String)
      value = Chronic.parse(value, context: :future)
      return super(nil) if value&.past?
    end

    super(value)
  end

  def waiting_for=(value)
    if value.blank?
      super(nil)
    else
      super(value)
    end
  end

  def missing_next_action?
    self.class.missing_next_action.exists?(id)
  end

  private

  def cannot_be_incubating_and_waiting_for
    if incubating? && waiting_for?
      errors.add(:base, "cannot be waiting for and incubating")
    end
  end

  def waiting_for_must_match_waiting_since
    if waiting_for? && waiting_since.blank?
      errors.add(:base, "cannot have waiting_for without waiting_since")
    elsif waiting_since.present? && waiting_for.blank?
      errors.add(:base, "cannot have waiting_since without waiting_for")
    end
  end
end

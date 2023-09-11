class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  scope :incubating, -> { where("incubating_until > ?", DateTime.current) }
  scope :active, -> { where("incubating_until <= ? OR incubating_until is null", DateTime.current) }

  def incubating?
    incubating_until&.future? || false
  end

  def incubating_until=(value)
    if value.is_a?(String)
      value = Chronic.parse(value, context: :future)
    end

    super(value)
  end
end

require "test_helper"

class InboxItemTest < ActiveSupport::TestCase
  test "processed_at is set if processed" do
    inbox_item = InboxItem.new(processed: true)
    assert_not inbox_item.valid?
    assert_equal ["must be set if processed"], inbox_item.errors[:processed_at]
  end

  test "must belong to a user" do
    inbox_item = InboxItem.new
    assert_not inbox_item.valid?
    assert_equal ["must exist"], inbox_item.errors[:user]
  end

  test "requires content" do
    inbox_item = InboxItem.new
    assert_not inbox_item.valid?
    assert_equal ["can't be blank"], inbox_item.errors[:content]
  end

  test "pinned? returns true if user's current pin is this item" do
    user = users(:ori)
    inbox_item = InboxItem.create!(user: user, content: "abc")
    user.update!(pinned_inbox_item: inbox_item)

    assert_predicate inbox_item, :pinned?
  end
end

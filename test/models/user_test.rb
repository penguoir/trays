require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:ori)
  end

  test "has many inbox items" do
    assert_equal [], @user.inbox_items

    inbox_item = InboxItem.create!(user: @user, content: "abc")
    assert_includes @user.reload.inbox_items, inbox_item
  end

  test "has one pinned inbox item" do
    assert_nil @user.pinned_inbox_item

    inbox_item = InboxItem.create!(user: @user, content: "abc")
    @user.update!(pinned_inbox_item: inbox_item)
    assert_equal inbox_item, @user.pinned_inbox_item

    # But not required
    @user.update!(pinned_inbox_item: nil)
  end
end

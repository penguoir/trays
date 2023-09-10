require "test_helper"

class InboxItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:ori)
  end

  test "should get new" do
    sign_in @user

    get new_inbox_item_url
    assert_response :success
  end

  test "stay on same page when adding to inbox" do
    sign_in @user

    get new_inbox_item_url
    assert_response :success

    post inbox_items_url, params: { inbox_item: { content: "abc" } }
    assert_redirected_to new_inbox_item_url
  end

  test "creates inbox item" do
    sign_in @user

    assert_difference("InboxItem.count") do
      post inbox_items_url, params: { inbox_item: {
        processed: false,
        content: "<p>Some content</p>",
      } }
    end

    assert_redirected_to new_inbox_item_url

    inbox_item = InboxItem.last
    assert_equal @user, inbox_item.user
    assert_equal false, inbox_item.processed
    assert_equal "<p>Some content</p>", inbox_item.content.body.to_html
  end

  test "processing inbox item" do
    sign_in @user

    inbox_item = InboxItem.create!(user: @user, content: "abc")
    assert_equal false, inbox_item.processed

    post processed_inbox_item_url(inbox_item)

    assert_redirected_to inbox_items_url
    assert_equal true, inbox_item.reload.processed
  end

  test "pinning inbox item" do
    sign_in @user

    inbox_item = InboxItem.create!(user: @user, content: "abc")

    post pin_inbox_item_url(inbox_item)

    assert_redirected_to inbox_items_url
    assert_equal inbox_item, @user.reload.pinned_inbox_item
  end
end

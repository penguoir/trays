require "test_helper"

class NextActionTest < ActiveSupport::TestCase
  setup do
    @user = users(:ori)
  end

  test ".incomplete scope is all incomplete next actions" do
    action = NextAction.create!(name: "Test", user: @user)
    assert_equal 1, NextAction.incomplete.count
    action.update(completed_at: Time.current)
    assert_equal 0, NextAction.incomplete.count
  end

  test "#complete? is true when completed_at is present" do
    action = NextAction.create!(name: "Test", user: @user)
    refute action.complete?
    action.update(completed_at: Time.current)
    assert action.complete?
  end
end

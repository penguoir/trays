require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "#incubating?" do
    project = Project.new
    assert_not_predicate project, :incubating?

    project = Project.new(incubating_until: 1.day.from_now)
    assert_predicate project, :incubating?

    travel 2.days do
      assert_not_predicate project, :incubating?
    end
  end

  test "can set incubating_until= with NLP" do
    project = Project.new
    project.incubating_until = "tomorrow"
    assert_equal 1.day.from_now.to_date, project.incubating_until.to_date
    assert_predicate project, :incubating?
  end

  test ".active is not waiting and not incubating" do
    project = Project.new
    assert_predicate project, :active?

    project.incubating_until = 1.day.from_now
    assert_predicate project, :incubating?
    assert_not_predicate project, :active?
    project.incubating_until = nil

    project.waiting_for = "something"
    assert_predicate project, :waiting_for?
    assert_not_predicate project, :active?
  end

  test "cannot set blank waiting for" do
    project = Project.new
    project.waiting_for = ""
    assert_nil project.waiting_for

    project.waiting_for = " "
    assert_nil project.waiting_for
  end

  test "project cannot be waiting for and incubating" do
    project = Project.new
    project.waiting_for = "something"
    project.waiting_since = 1.day.ago
    project.incubating_until = 1.day.from_now
    assert_not project.valid?
    assert_equal ["cannot be waiting for and incubating"], project.errors[:base]
  end

  test "cannot have waiting_since without waiting_for" do
    project = Project.new
    project.waiting_since = 1.day.ago
    assert_not project.valid?
    assert_equal ["cannot have waiting_since without waiting_for"], project.errors[:base]
  end

  test "cannot have waiting_for without waiting_since" do
    project = Project.new
    project.waiting_for = "something"
    assert_not project.valid?
    assert_equal ["cannot have waiting_for without waiting_since"], project.errors[:base]
  end

  test "missing next action" do
    project = Project.create!(name: "Project", user: users(:ori))
    assert_empty project.next_actions
    assert_predicate project, :missing_next_action?

    project.next_actions << NextAction.new(user: users(:ori), name: "Next Action")
    assert_not_predicate project, :missing_next_action?
  end
end

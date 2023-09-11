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

  test ".active scope is opposite of incubating" do
    project = Project.new
    assert_predicate project, :active?

    project = Project.new(incubating_until: 1.day.from_now)
    assert_not_predicate project, :active?
  end
end

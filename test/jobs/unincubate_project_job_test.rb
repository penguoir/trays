require "test_helper"

class UnincubateProjectJobTest < ActiveJob::TestCase
  setup do
    @user = users(:ori)
    @project = Project.create(name: "Test", user: @user, incubating_until: 1.day.from_now)
  end

  test "unincubate project" do
    UnincubateProjectJob.perform_now(@project)
    assert_in_delta 1.day.from_now, @project.incubating_until, 0.1

    travel_to 2.days.from_now do
      UnincubateProjectJob.perform_now(@project)
      assert_nil @project.incubating_until
    end
  end

  test "creates an inbox item when unincubating" do
    assert_no_difference "@user.inbox_items.count" do
      UnincubateProjectJob.perform_now(@project)
    end

    travel_to 2.days.from_now do
      assert_difference "@user.inbox_items.count" do
        UnincubateProjectJob.perform_now(@project)
      end
    end
  end

  test "re-enqueues itself when project is still incubating" do
    assert_enqueued_with(job: UnincubateProjectJob, args: [@project], at: 1.day.from_now) do
      UnincubateProjectJob.perform_now(@project)
    end
  end

  test "skips if already unincubated" do
    @project.update!(incubating_until: nil)

    assert_no_difference "@user.inbox_items.count" do
      assert_no_enqueued_jobs do
        UnincubateProjectJob.perform_now(@project)
      end
    end
  end
end

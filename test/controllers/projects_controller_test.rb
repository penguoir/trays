require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:ori)

    sign_in @user
  end

  test "updating waiting_for also updates waiting_since" do
    project = Project.create!(name: "test", user: @user)
    assert_nil project.waiting_since

    # Sets waiting_since
    patch project_url(project), params: { project: { waiting_for: "something" } }
    assert_redirected_to project_url(project)
    assert_not_nil project.reload.waiting_since

    waiting_since = project.waiting_since

    # Keeps waiting_since the same
    travel_to 1.day.from_now do
      patch project_url(project), params: { project: { waiting_for: "something else" } }
      assert_redirected_to project_url(project)
      assert_equal waiting_since, project.reload.waiting_since
    end

    # Unless we remove waiting_for entirely
    travel_to 1.day.from_now do
      patch project_url(project), params: { project: { waiting_for: "" } }
      assert_redirected_to project_url(project)
      assert_nil project.reload.waiting_since
    end
  end

  test "updating incubating_until enqueues a UnincubateProjectJob" do
    project = Project.create!(name: "test", user: @user)
    assert_nil project.incubating_until

    assert_enqueued_with(job: UnincubateProjectJob, args: [project], at: "2040-09-01 12:00".to_datetime) do
      patch project_url(project), params: { project: { incubating_until: "1 september 2040" } }
    end
  end
end

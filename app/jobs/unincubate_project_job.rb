class UnincubateProjectJob < ApplicationJob
  queue_as :default

  def perform(project)
    return if project.incubating_until.nil?

    if project.incubating_until.past?
      ActiveRecord::Base.transaction do
        project.update!(incubating_until: nil)
        project.user.inbox_items.create!(content: content(project))
      end
    else
      project.unincubate_later
    end
  end

  private

  def content(project)
    <<~CONTENT
    <p>
      Your project 

      <a class="text-blue-500 underline" href="#{project_path(project)}">
        #{project.name}
      </a>

      is no longer incubating.
    </p>
    CONTENT
  end

  def project_path(project)
    Rails.application.routes.url_helpers.project_path(project)
  end
end

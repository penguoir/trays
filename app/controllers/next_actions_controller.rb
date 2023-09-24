class NextActionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  layout 'third'

  def index
    @next_actions = NextAction.where(user: current_user)
    @incomplete_next_actions = @next_actions.incomplete
  end

  def new
    @next_action = NextAction.new

    if params[:project_id]
      @next_action.projects << Project.find(params[:project_id])
    end
  end

  def create
    @next_action = NextAction.create(next_action_params)
    respond_with @next_action, location: -> { next_actions_path }
  end

  def complete
    @next_action = NextAction.find(params[:id])
    @next_action.update(completed_at: Time.current)
    respond_with @next_action
  end

  def incomplete
    @next_action = NextAction.find(params[:id])
    @next_action.update(completed_at: nil)
    respond_with @next_action
  end

  def completed
    @next_actions = NextAction.where(user: current_user).complete
  end

  def destroy
    @next_action = NextAction.find(params[:id])
    @next_action.destroy

    respond_with @next_action, location: -> { next_actions_path }
  end

  def edit
    @next_action = NextAction.find(params[:id])
  end

  def update
    @next_action = NextAction.find(params[:id])
    @next_action.update(next_action_params)

    respond_with @next_action, location: -> { next_actions_path }
  end

  private

  def next_action_params
    params.require(:next_action)
      .permit(:name, :project_ids => [])
      .merge(user: current_user)
  end
end

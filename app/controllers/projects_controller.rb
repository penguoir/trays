class ProjectsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  def index
    first_project = Project.active.first

    if first_project
      redirect_to first_project
    else
      redirect_to new_project_path
    end
  end

  def show
    @projects = Project.all
    @project = Project.find_by(id: params[:id])
  end

  def edit
    redirect_to project_path(params[:id])
  end

  def new
    @projects = Project.all
    @project = Project.new
  end

  def create
    @project = Project.create(project_params)
    respond_with @project
  end

  def update
    @project = Project.find_by(id: params[:id])
    @project.update(project_params)

    respond_with @project
  end

  def destroy
    @project = Project.find_by(id: params[:id])
    @project.destroy

    redirect_to projects_path
  end

  private

  def project_params
    params
      .require(:project)
      .permit(:name, :content, :incubating_until, :waiting_for)
      .merge(user: current_user)
  end
end

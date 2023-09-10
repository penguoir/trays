class ProjectsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by(id: params[:id])
  end

  def new
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
      .permit(:name, :content)
      .merge(user: current_user)
  end
end

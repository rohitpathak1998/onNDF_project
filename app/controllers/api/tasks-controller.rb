class Api::TasksController < ApplicationController
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
	rescue_from ActionController::ParameterMissing, with: :parameter_missing 

	before_action :authenticate_user!
	# before_action :authorize_admin!, only: [:create]
	def index
		@tasks = Task.all
		render json: @tasks, only:[:name, :location]
	end

	def create
		@task = Task.new(task_params)

		if @task.save!
			render json: { message: "Task created successfully" }
		else
			render json: {error: 'Unauthorized user'}, status: :unauthorized unless current_user.admin?
		end
	end

	private

	# def authorize_admin!
	# 	render json: {error: 'Unauthorized user'}, status: :unauthorized unless current_user.admin?
	# end

	def record_not_found
		render json: {error: 'Record not found'}, status: :not_found
	end

	def parameter_missing
		render json: {error: 'Missing parameter'}, status: :bad_request
	end

	def task_params
		params.require(:task).permit(:name, :location)
	end
end

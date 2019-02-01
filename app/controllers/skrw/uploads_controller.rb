require_dependency 'skrw/application_controller'

module Skrw
  class UploadsController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def create
      @upload = resource.new(upload_params)
      if @upload.save
        render_upload(status: :created)
      else
        render_upload(status: :unprocessable_entity)
      end
    end

    def update
      @upload = resource.find(params[:id])
      if @upload.update_attributes(upload_params)
        render_upload(status: :ok)
      else
        @object = @upload
        render_upload(status: :unprocessable_entity)
      end
    end

    def destroy
      @upload = resource.find(params[:id])
      if @upload.destroy
        render_upload(status: :ok)
      end
    end

    def resource
      Skrw::Upload
    end

    def render_upload(status: nil)
      render 'upload', status: status
    end

    private

      def upload_params
        params.require(:upload).permit(:file, :uploadable_type, :uploadable_id)
      end
  end
end

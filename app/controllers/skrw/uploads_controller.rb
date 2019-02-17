require_dependency 'skrw/application_controller'

module Skrw
  class UploadsController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    # index all uploads or uploads within the scope of parent
    # with the params :uploadable_type and :uploadable_id in params
    
    def index
      uploads = resource.where(uploadable_type: params[:uploadable_type], uploadable_id: params[:uploadable_id])
      @uploads = uploads.chrono
    end

    # create upload and return upload.json or errors.json

    def create
      @upload = resource.new(upload_params)
      if @upload.save
        flash.now[:notice] = "file upload successful"
        render_upload(status: :created)
      else
        flash.now[:error] = "file upload failed"
        render_upload(status: :unprocessable_entity)
      end
    end

    # update upload and return upload.json or errors.json

    def update
      @upload = resource.find(params[:id])
      if @upload.update_attributes(upload_params)
        flash.now[:notice] = "file upload update successful"
        render_upload(status: :created)
      else
        flash.now[:error] = "file upload update failed"
        render_upload(status: :unprocessable_entity)
      end
    end

    # destroy upload and return upload.json

    def destroy
      @upload = resource.find(params[:id])
      if @upload.destroy
        # return form with fresh resource
        @upload = resource.new(uploadable_type: @upload.uploadable_type, uploadable_id: @upload.uploadable_id)
        render_upload(status: :ok)
      end
    end

    # define resource used as Model

    def resource
      Skrw::Upload
    end

    def render_upload(status: nil)
      render 'form', status: status
    end

    private

      def upload_params
        params.require(:upload).permit(:file, :uploadable_type, :uploadable_id)
      end
  end
end

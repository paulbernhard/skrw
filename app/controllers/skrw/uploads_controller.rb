require_dependency 'skrw/application_controller'

module Skrw
  class UploadsController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    # index all uploads or uploads within the scope of parent
    # with the params :uploadable_type and :uploadable_id in params
    
    def index
      @uploads = resource.where(uploadable_type: params[:uploadable_type], uploadable_id: params[:uploadable_id]).chronological
    end

    # create upload and return upload.json or errors.json

    def create
      @upload = resource.new(upload_params)
      if @upload.save
        render_upload(status: :created)
      else
        @object = @upload
        render 'skrw/shared/errors', status: :unprocessable_entity
      end
    end

    # update upload and return upload.json or errors.json

    def update
      @upload = resource.find(params[:id])
      if @upload.update_attributes(upload_params)
        render_upload(status: :ok)
      else
        @object = @upload
        render 'skrw/shared/errors', status: :unprocessable_entity
      end
    end

    # destroy upload and return upload.json

    def destroy
      @upload = resource.find(params[:id])
      if @upload.destroy
        render_upload(status: :ok)
      end
    end

    # define resource used as Model

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

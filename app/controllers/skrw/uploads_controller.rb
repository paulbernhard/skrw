require_dependency "skrw/application_controller"

module Skrw
  class UploadsController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def create
      @upload = resource.new(upload_params)
      if @upload.save
        render 'show.json.jbuilder', status: 200, location: @upload
      else
        @object = @upload
        render 'skrw/shared/errors.json.jbuilder', status: :unprocessable_entity
      end
    end

    def destroy
      @upload = resource.find(params[:id])
      if @upload.destroy
        render 'show.json.jbuilder', status: 200
      end
    end

    def resource
      Skrw::Upload
    end

    private

      def upload_params
        params.require(:upload).permit(:file, :uploadable_type, :uploadable_id)
      end
  end
end

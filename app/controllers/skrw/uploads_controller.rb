require_dependency "skrw/application_controller"

module Skrw
  class UploadsController < ApplicationController
    before_action :authenticate_user!

    def create
      @upload = Skrw::Upload.new(upload_params)
      @upload.save
      respond_to do |format|
        format.json { render :show, status: 200, location: @upload }
      end
    end

    def destroy
      @upload = Skrw::Upload.find(params[:id])
      @upload.destroy
      respond_to do |format|
        format.json { render :show, status: 200 }
      end
    end

    private

      def upload_params
        params.require(:upload).permit(:file, :uploadable_type, :uploadable_id)
      end
  end
end

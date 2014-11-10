class V1::PhotosController < V1::BaseController
  api :GET, "/v1/photos/:id", "Returns a photo"

  def show(photo = nil)
    photo ||= current_user.photos.find(params[:id])
    render json: {
      id: photo.id,
      url: photo.file.url,
      small_url: photo.file.small.url,
    }
  end

  api :POST, "/v1/photos", "Creates a photo"
  param :photo, Hash, required: true do
    param :file, File, desc: "Photo", required: true
  end

  def create
    @interactor = CreatePhoto.new(create_photo_params)
    @interactor.user = current_user
    @interactor.perform
    show @interactor.photo
  end

  private

  def create_photo_params
    params.require(:photo).permit(:file)
  end
end

require "test_helper"

class V1::PhotosControllerTest < ActionController::TestCase
  test "show renders template" do
    user = create(:user)
    @controller.sign_in(user, user.authentication_token)
    photo = create(:photo, user: user)
    get :show, id: photo.id, format: "json"
    assert_response 200
  end

  test "show responds with unauthorized" do
    photo = create(:photo)
    get :show, id: photo.id, format: "json"
    assert_response :unauthorized
  end

  test "show responds with not found" do
    user = create(:user)
    @controller.sign_in(user, user.authentication_token)
    photo = create(:photo)
    get :show, id: photo.id, format: "json"
    assert_response :not_found
  end

  # test "create responds with created" do
  #   user = create(:user, :authenticated)
  #   post :create, photo: {file: Rack::Test::UploadedFile.new(file_fixture("image.png")) }, auth: user.authentication_token, format: "json"
  #   assert_response :created
  # end

  test "create responds with unauthorized when no auth" do
    post :create, photo: {file: nil}, format: "json"
    assert_response :unauthorized
  end

  test "create responds with unprocessable entity" do
    user = create(:user)
    @controller.sign_in(user, user.authentication_token)
    post :create, photo: {file: nil}, format: "json"
    assert_response :unprocessable_entity
  end
end

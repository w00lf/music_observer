require 'test_helper'

class ConcertsControllerTest < ActionController::TestCase
  setup do
    @concert = concerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:concerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create concert" do
    assert_difference('Concert.count') do
      post :create, concert: { api_link: @concert.api_link, artist_id: @concert.artist_id, country: @concert.country, description: @concert.description, sity: @concert.sity, start_date: @concert.start_date, street: @concert.street, title: @concert.title }
    end

    assert_redirected_to concert_path(assigns(:concert))
  end

  test "should show concert" do
    get :show, id: @concert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @concert
    assert_response :success
  end

  test "should update concert" do
    put :update, id: @concert, concert: { api_link: @concert.api_link, artist_id: @concert.artist_id, country: @concert.country, description: @concert.description, sity: @concert.sity, start_date: @concert.start_date, street: @concert.street, title: @concert.title }
    assert_redirected_to concert_path(assigns(:concert))
  end

  test "should destroy concert" do
    assert_difference('Concert.count', -1) do
      delete :destroy, id: @concert
    end

    assert_redirected_to concerts_path
  end
end

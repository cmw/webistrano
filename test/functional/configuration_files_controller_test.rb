require 'test_helper'

class ConfigurationFilesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:configuration_files)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_configuration_file
    assert_difference('ConfigurationFile.count') do
      post :create, :configuration_file => { }
    end

    assert_redirected_to configuration_file_path(assigns(:configuration_file))
  end

  def test_should_show_configuration_file
    get :show, :id => configuration_files(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => configuration_files(:one).id
    assert_response :success
  end

  def test_should_update_configuration_file
    put :update, :id => configuration_files(:one).id, :configuration_file => { }
    assert_redirected_to configuration_file_path(assigns(:configuration_file))
  end

  def test_should_destroy_configuration_file
    assert_difference('ConfigurationFile.count', -1) do
      delete :destroy, :id => configuration_files(:one).id
    end

    assert_redirected_to configuration_files_path
  end
end

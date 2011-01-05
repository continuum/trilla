require 'test_helper'

class TareasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tareas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tarea" do
    assert_difference('Tarea.count') do
      post :create, :tarea => { }
    end

    assert_redirected_to tarea_path(assigns(:tarea))
  end

  test "should show tarea" do
    get :show, :id => tareas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tareas(:one).to_param
    assert_response :success
  end

  test "should update tarea" do
    put :update, :id => tareas(:one).to_param, :tarea => { }
    assert_redirected_to tarea_path(assigns(:tarea))
  end

  test "should destroy tarea" do
    assert_difference('Tarea.count', -1) do
      delete :destroy, :id => tareas(:one).to_param
    end

    assert_redirected_to tareas_path
  end
end

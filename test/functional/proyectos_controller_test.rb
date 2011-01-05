require 'test_helper'

class ProyectosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proyectos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proyecto" do
    assert_difference('Proyecto.count') do
      post :create, :proyecto => { }
    end

    assert_redirected_to proyecto_path(assigns(:proyecto))
  end

  test "should show proyecto" do
    get :show, :id => proyectos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proyectos(:one).to_param
    assert_response :success
  end

  test "should update proyecto" do
    put :update, :id => proyectos(:one).to_param, :proyecto => { }
    assert_redirected_to proyecto_path(assigns(:proyecto))
  end

  test "should destroy proyecto" do
    assert_difference('Proyecto.count', -1) do
      delete :destroy, :id => proyectos(:one).to_param
    end

    assert_redirected_to proyectos_path
  end
end

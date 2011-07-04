require 'test_helper'

class ContactosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contactos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contacto" do
    assert_difference('Contacto.count') do
      post :create, :contacto => { }
    end

    assert_redirected_to contacto_path(assigns(:contacto))
  end

  test "should show contacto" do
    get :show, :id => contactos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => contactos(:one).to_param
    assert_response :success
  end

  test "should update contacto" do
    put :update, :id => contactos(:one).to_param, :contacto => { }
    assert_redirected_to contacto_path(assigns(:contacto))
  end

  test "should destroy contacto" do
    assert_difference('Contacto.count', -1) do
      delete :destroy, :id => contactos(:one).to_param
    end

    assert_redirected_to contactos_path
  end
end

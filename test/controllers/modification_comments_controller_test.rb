require 'test_helper'

class ModificationCommentsControllerTest < ActionController::TestCase
  setup do
    @modification_comment = modification_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modification_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create modification_comment" do
    assert_difference('ModificationComment.count') do
      post :create, modification_comment: { body: @modification_comment.body, modification_id: @modification_comment.modification_id, user_id: @modification_comment.user_id }
    end

    assert_redirected_to modification_comment_path(assigns(:modification_comment))
  end

  test "should show modification_comment" do
    get :show, id: @modification_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @modification_comment
    assert_response :success
  end

  test "should update modification_comment" do
    patch :update, id: @modification_comment, modification_comment: { body: @modification_comment.body, modification_id: @modification_comment.modification_id, user_id: @modification_comment.user_id }
    assert_redirected_to modification_comment_path(assigns(:modification_comment))
  end

  test "should destroy modification_comment" do
    assert_difference('ModificationComment.count', -1) do
      delete :destroy, id: @modification_comment
    end

    assert_redirected_to modification_comments_path
  end
end

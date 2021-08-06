class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def show
    friends = []
    friendships = @user.friendships.where(user_id: @user.id)
    friendships.each do |f|
      friends << f.friend_id
    end
    render json: {
      id: @user.id,
      name: @user.name,
      friends: friends
    }
  end

  def create
    user = User.new(user_params)
    if user.save!
      render json: {
        message: 'ユーザ登録に成功しました',
        user: user
      }
    else
      render json: {
        message: 'ユーザ登録に失敗しました'
      }
    end
  end

  def update
    if @user.update!(user_params)
      render json: {
        message: 'ユーザー名を更新しました',
        user: @user
      }
    else
      render json: {
        message: 'ユーザー名の更新に失敗しました'
      }
    end
  end

  def destroy
    if @user.destroy!
      render json: {
        message: 'ユーザを削除しました',
        user: @user
      }
    else
      render json: {
        message: 'ユーザ削除に失敗しました'
      }
    end
  end

  private

  def user_params
    params.permit(:name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    friendships = user.friendships.where(user_id: user.id)
    friends = []
    friendships.each do |f|
      friends << f.friend_id
    end
    render json: {
      id: user.id,
      name: user.name,
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
    user = User.find(params[:id])
    if user.update!(user_params)
      render json: {
        message: 'ユーザー名を更新しました',
        user: user
      }
    else
      render json: {
        message: 'ユーザー名の更新に失敗しました'
      }
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    render json: {
      message: 'ユーザ登録を削除しました',
      user: user
    }
  end

  private
  def user_params
    params.permit(:name)
  end
end

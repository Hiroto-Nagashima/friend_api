require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    @user1 = User.create(name: 'Taro')
    @user2 = User.create(name: 'Jiro')
  end

  describe '#presence' do
    context 'success' do
      it 'ユーザーと友人が存在していれば有効' do
        friendship = Friendship.new(user_id: @user1.id, friend_id: @user2.id)
        expect(friendship).to be_valid
      end
    end

    context 'error' do
      it '友人が存在しなければ無効' do
        friendship = Friendship.new(user_id: @user1.id, friend_id: nil)
        friendship.valid?
        expect(friendship.errors.messages[:friend_id]).to include("can't be blank")
      end
    end
  end

  describe '#custom validator' do
    context 'error' do
      it 'ユーザーと友人が同一人物なら無効' do
        friendship = Friendship.new(user_id: @user1.id, friend_id: @user1.id)
        friendship.valid?
        expect(friendship.errors[:user_id]).to include('User and friend must be different')
      end

      it '友人が存在しないユーザーの場合無効' do
        friendship = Friendship.new(user_id: @user1.id, friend_id: 100)
        friendship.valid?
        expect(friendship.errors.messages[:friend_id]).to include("Friend must exist")
      end
    end
  end

  describe '#uniqueness' do
    context 'error' do
      it 'あるユーザーが他の特定のユーザーを2回友人に登録すれば無効' do
        friendship1 = Friendship.create!(user_id: @user1.id, friend_id: @user2.id)
        friendship2 = Friendship.new(user_id: @user1.id, friend_id: @user2.id)
        friendship2.valid?
        expect(friendship2.errors[:user_id]).to include('has already been taken')
      end
    end
  end
end
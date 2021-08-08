require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  before do
    @user1 = User.create(name: 'Hanako')
    @user2 = User.create(name: 'Takeshi')
    @user3 = User.create(name: 'Saburo')
    Friendship.create(user_id: @user1.id, friend_id: @user2.id)
    Friendship.create(user_id: @user1.id, friend_id: @user3.id)
  end

  describe 'GET /users/:id' do
    context 'success' do
      before do
        get "/api/v1/users/#{@user1.id}"
        @json = JSON.parse(response.body)
      end

      it 'リクエストが成功しているか' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザーのIDが含まれているか' do
        expect(@json['id']).to eq(@user1.id)
      end

      it 'ユーザーの名前が含まれているか' do
        expect(@json['name']).to eq('Hanako')
      end

      it 'ユーザーの全ての友人のIDが含まれているか' do
        expect(@json['friends']).to eq([@user2.id, @user3.id])
      end
    end

    context 'error' do
      it 'ユーザーが存在しない場合無効' do
        expect{get "/api/v1/users/10"}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /users/' do
    it 'ユーザーを作成' do
      expect{post "/api/v1/users", params: { name: 'Hitoshi' }}.to change(User, :count).by(+1)
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /users/:id' do
    it 'ユーザーを削除' do
      # post "/api/v1/users/#{user.id}/register_image", params: { image: params }
      # expect(user.image).not_to eq(nil)
      # expect(response).to have_http_status(200)
    end
  end



  # describe 'PUT /users/:id' do
  #   it 'ユーザーの情報を更新' do
  #     user = create(:user)
  #     put "/api/v1/users/#{user.id}", params: { params: {
  #       first_name: user.first_name,
  #       last_name: '山本',
  #       email: user.email,
  #       telephone_number: user.telephone_number
  #       } }
  #       json = JSON.parse(response.body)
  #       expect(json["user"]['lastName']).to eq('山本')
  #       expect(response).to have_http_status(200)
  #     end
  #   end
  end
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
    context 'success 有効なパラメータの場合' do
      it 'リクエストが成功しているか' do
        post "/api/v1/users", params: { name: 'Hitoshi' }
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが登録されるか' do
        expect{post "/api/v1/users", params: { name: 'Hitoshi' }}.to change(User, :count).by(+1)
      end

      it '期待するメッセージが返ってくるか' do
        post "/api/v1/users", params: { name: 'Hitoshi' }
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ユーザ登録に成功しました')
      end
    end

    context 'error 無効なパラメーターの時' do
      it 'リクエストが成功しているか' do
        post "/api/v1/users", params: { name: nil }
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが登録されないか' do
        expect{post "/api/v1/users", params: { name: nil }}.to_not change(User, :count)
      end

      it '期待するメッセージが返ってくるか' do
        post "/api/v1/users", params: { name: nil }
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ユーザ登録に失敗しました')
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      User.create(name: 'Taro')
      @user = User.find_by(name: 'Taro')
    end

    context 'success 有効なパラメータの場合' do
      before do
        put "/api/v1/users/#{@user.id}", params: { name: 'Tarou' }
      end

      it 'リクエストが成功しているか' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザーの名前が更新されるか' do
        expect(@user.reload.name).to eq('Tarou')
      end

      it '期待するメッセージが返ってくるか' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ユーザー名を更新しました')
      end
    end

    context 'error 無効なパラメーターの時' do
      before do
        put "/api/v1/users/#{@user.id}", params: { name: nil }
      end

      it 'リクエストが成功しているか' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが名前が更新されていないか' do
        expect(@user.name).to eq('Taro')
      end

      it '期待するメッセージが返ってくるか' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ユーザー名の更新に失敗しました')
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      User.create(name: 'Taro')
      @user = User.find_by(name: 'Taro')
    end

    context 'success 有効なパラメータの場合' do
      it 'リクエストが成功しているか' do
        delete "/api/v1/users/#{@user.id}"
        expect(response).to have_http_status(200)
      end

      it 'ユーザーの名前が更新されるか' do
        expect{delete "/api/v1/users/#{@user.id}"}.to change(User, :count).by(-1)
      end

      it '期待するメッセージが返ってくるか' do
        delete "/api/v1/users/#{@user.id}"
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ユーザを削除しました')
      end
    end

    context 'error 無効なパラメーターの時' do
      it 'ユーザーIDがnilの場合無効' do
        expect{delete "/api/v1/users/nil"}.to raise_error ActiveRecord::RecordNotFound
      end

      it 'ユーザーIDが存在しないIDの場合無効' do
        expect{delete "/api/v1/users/100"}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
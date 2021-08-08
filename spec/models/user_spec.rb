require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#presence' do
    context 'success' do
      it '名前が存在すれば有効' do
        user = User.new(name: 'Tarou')
        expect(user).to be_valid
      end
    end

    context 'error' do
      it '名前が存在しなければ無効' do
        user = User.new(name: nil)
        user.valid?
        expect(user.errors.messages[:name]).to include("can't be blank")
      end
    end

  end

  describe '#uniqueness' do
    context 'success' do
      it 'ユーザー同士が異なる名前を使えば有効' do
        User.create(name: 'Alice')
        user = User.new(name: 'Tarou')
        expect(user).to be_valid
      end
    end

    context 'error' do
      it 'ユーザー同士で同じ名前を使うと無効' do
        User.create(name: 'Jiro')
        user = User.new(name: 'Jiro')
        user.valid?
        expect(user.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe '#length' do
    context 'success' do
      it '20字以内の名前を使用すれば有効' do
        user = User.new(name: '123456789123456789')
        expect(user).to be_valid
      end
    end
    context 'error' do
      it '21字以上の名前を使うと無効' do
        user = User.new(name: '123456789123456789123')
        user.valid?
        expect(user.errors.messages[:name]).to include('is too long (maximum is 20 characters)')
      end
    end
  end
end
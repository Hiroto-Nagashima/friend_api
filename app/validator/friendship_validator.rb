class FriendshipValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == record.friend_id
      record.errors.add :user_id, '自分を友達に登録できません'
    end

    if User.find_by(id: record.friend_id) == nil && record.friend_id != nil
      record.errors.add :friend_id, 'Friend must exist '
    end
  end
end
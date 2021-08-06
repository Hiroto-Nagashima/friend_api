class FriendshipValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == record.friend_id
      record.errors.add :user_id, '自分を友達に登録できません'
    end
  end
end
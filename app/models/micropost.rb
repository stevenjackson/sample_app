class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  default_scope order: 'microposts.created_at DESC'
  
  def Micropost.from_users_followed_by(user)
    followed_ids = user.followed_user_ids
    Micropost.where("user_id in (?) or user_id = ?", followed_ids, user)
  end
end

class User < ActiveRecord::Base
  validates :oauth_token, :oauth_secret, presence: true
  validates :username, uniqueness: true

end

class User < ActiveRecord::Base
  def password=(val)
    val = BCrypt::Password.create(val)
    super(val)
  end
end

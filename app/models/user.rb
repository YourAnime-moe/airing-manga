class User < ApplicationRecord
  has_one :youranime_user
  has_one :mangadex_user

  def refresh_if_expired
    youranime_user.refresh_if_expired
  end

  def logout
    youranime_user.logout
  end
end

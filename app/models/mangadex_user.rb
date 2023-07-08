class MangadexUser < ApplicationRecord
  def access_token_expired?
    session_valid_until.present? && Time.current >= session_valid_until
  end
end

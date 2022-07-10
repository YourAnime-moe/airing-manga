class YouranimeUser < ApplicationRecord
  belongs_to :user, inverse_of: :youranime_user

  def access_token_expired?
    access_token_expires_on.present? && Time.current >= access_token_expires_on
  end

  def refresh_if_expired(force: false)
    return unless access_token_expired? || force
    return if refresh_token.blank?

    options = {
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: Rails.application.credentials.oauth.misete.client_id,
      client_secret: Rails.application.credentials.oauth.misete.client_secret,
    }

    uri = URI("https://id.youranime.moe")
    uri.path = "/oauth/token"
    uri.query = options.to_query

    response = RestClient.post(uri.to_s, {})
    grant_token = JSON.parse(response.body)

    user_info = RestClient.get("https://id.youranime.moe/me.json?access_token=#{grant_token["access_token"]}")
    user_info = JSON.parse(user_info.body)

    update(
      access_token: grant_token["access_token"],
      refresh_token: grant_token["refresh_token"],
      access_token_expires_on: grant_token["expires_in"]&.seconds&.from_now,
      username: user_info["username"],
    )
  end

  def logout
    options = {
      client_id: Rails.application.credentials.oauth.misete.client_id,
      client_secret: Rails.application.credentials.oauth.misete.client_secret,
      token: access_token,
    }

    uri = URI("https://id.youranime.moe")
    uri.path = "/oauth/revoke"
    uri.query = options.to_query

    RestClient.post(uri.to_s, {})
  end
end

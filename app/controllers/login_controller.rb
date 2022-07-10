class LoginController < ApplicationController
  def youranime
    session[:return_to] ||= request.referer
    redirect_to(youranime_login_url, allow_other_host: true)
  end

  def youranime_callback
    grant_token_url = youranime_grant_token_url(params[:code])
    response = RestClient.post(grant_token_url, {})
    grant_token = JSON.parse(response.body)
    
    access_token = grant_token["access_token"]
    response = RestClient.get(youranime_user_info(access_token))
    user_info = JSON.parse(response.body)

    session[:user] = find_or_build_youranime_user(user_info, grant_token).user.id
    return_to_url = session.delete(:return_to) || root_path

    redirect_to(return_to_url)
  end

  def logout
    return_to_url = request.referer || root_path
    if logged_in?
      current_user.logout
      session.delete(:user)
    end
    redirect_to(return_to_url)
  end

  private

  def youranime_login_url
    options = {
      response_type: :code,
      client_id: Rails.application.credentials.oauth.misete.client_id,
      redirect_uri: 'http://localhost:3000/auth/misete/callback',
      scope: 'profile',
    }

    uri = URI("https://id.youranime.moe")
    uri.path = "/oauth/authorize"
    uri.query = options.to_query

    uri.to_s
  end

  def youranime_grant_token_url(code)
    options = {
      grant_type: :authorization_code,
      code: code,
      redirect_uri: 'http://localhost:3000/auth/misete/callback',
      client_id: Rails.application.credentials.oauth.misete.client_id,
      client_secret: Rails.application.credentials.oauth.misete.client_secret,
    }

    uri = URI("https://id.youranime.moe")
    uri.path = "/oauth/token"
    uri.query = options.to_query

    uri.to_s
  end

  def youranime_user_info(access_token)
    options = {
      access_token: access_token,
    }

    uri = URI("https://id.youranime.moe")
    uri.path = "/me.json"
    uri.query = options.to_query

    uri.to_s
  end

  def find_or_build_youranime_user(user_info, grant_token)
    youranime_user = YouranimeUser.find_by(uuid: user_info["uuid"])
    youranime_user = if youranime_user.present?
      youranime_user.assign_attributes(
        username: user_info["username"],
      )
      youranime_user
    else
      user = User.create
      user.build_youranime_user(
        uuid: user_info["uuid"],
      )
    end
    youranime_user.assign_attributes(
      access_token: grant_token["access_token"],
      refresh_token: grant_token["refresh_token"],
      access_token_expires_on: grant_token["expires_in"]&.seconds&.from_now,
      username: user_info["username"],
    )
    youranime_user.save!
    youranime_user
  end
end

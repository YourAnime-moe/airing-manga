class ApplicationController < ActionController::Base
  include ApplicationHelper

  protected

  def check_logged_in_user
    user = User.find_by(id: session[:user])
    return unless user.present?

    user.refresh_if_expired
  end
end

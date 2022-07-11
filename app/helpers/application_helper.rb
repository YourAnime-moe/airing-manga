require "redcarpet/render_strip"

module ApplicationHelper
  def current_youranime_user
    @current_youranime_user ||= YouranimeUser.find_by(id: session.dig(:user, "youranime"))
  end

  def current_mangadex_user

  end

  def logged_in?
    current_youranime_user.present? || current_mangadex_user.present?
  end

  def manga_title(manga, locale = I18n.locale)
    title_value(manga.title, locale)
  end

  def unformatted_description(manga, locale = I18n.locale)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    markdown.render(title_value(manga.description, locale))
  end

  def title_value(title, locale = I18n.locale)
    title[locale] || title[title.keys.first]
  end
end

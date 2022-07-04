module ApplicationHelper
  def manga_title(manga, locale = I18n.locale)
    manga.title[locale] || manga.title[manga.title.keys.first]
  end
end

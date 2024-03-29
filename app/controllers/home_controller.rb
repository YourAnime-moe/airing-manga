class HomeController < ApplicationController
  include HomeConcern

  before_action :check_logged_in_user
  after_action :register_readable_manga, only: :discover

  def index
    @readable = FetchReadableRandomManga.perform(I18n.locale)
    redirect_to(discover_path(@readable.manga.id))
  end

  def discover
    @readable = FetchReadableRandomManga.perform(I18n.locale, from_id: params[:id])
  end

  def discoveries
    ids = discovered_manga_ids.reverse.first(100)

    result = Mangadex::Manga.list(
      ids: ids,
      limit: ids.length,
      includes: :cover_art,
      content_rating: Mangadex::ContentRating::VALUES,
    ).data

    @manga = ids.map do |id|
      result.find { |manga| manga.id == id }
    end.compact
  end
end

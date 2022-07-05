class HomeController < ApplicationController
  include HomeConcern

  after_action :register_readable_manga, only: :discover

  def index
    @readable = FetchReadableRandomManga.perform(I18n.locale)
    redirect_to(discover_path(@readable.manga.id))
  end

  def discover
    @readable = FetchReadableRandomManga.perform(I18n.locale, from_id: params[:id])
    # if @readable.manga.id != params[:id]
    #   redirect_to(root_path)
    # end
  end

  def discoveries
    ids = discovered_manga_ids.reverse.first(100)

    result = Mangadex::Manga.list(
      ids: ids,
      limit: ids.length,
      includes: :cover_art,
    ).data

    @manga = ids.map do |id|
      result.find { |manga| manga.id == id }
    end
  end
end

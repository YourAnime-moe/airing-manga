class MangaController < ApplicationController
  def show
    @manga = Mangadex::Manga.get(params[:id], includes: :cover_art).data
  end
end

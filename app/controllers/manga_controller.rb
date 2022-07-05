class MangaController < ApplicationController
  def show
    # @manga = Mangadex::Manga.get(params[:id], includes: :cover_art).data
    redirect_to("https://mangadex.org/title/#{params[:id]}", allow_other_host: true)
  end
end

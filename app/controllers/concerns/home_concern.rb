require 'open-uri'

module HomeConcern
  extend ActiveSupport::Concern

  included do
    def register_readable_manga
      session[:discover_history] ||= []
      session[:discover_history] << @readable.manga.id

      session[:discover_history].uniq!
    end

    def discovered_manga_ids
      Array.wrap(session[:discover_history])
    end

    def serve_chapter
      id = params[:id]
      chapter = Rails.cache.fetch("chapter-#{id}") do
        Mangadex::Chapter.get(id)
      end.data

      cover = chapter.page_urls[params[:page].to_i - 1]
      tmp_file = Tempfile.new
      File.open(tmp_file.path, 'wb') do |f|
        f << URI.open(cover).read
      end

      send_data tmp_file.read, disposition: 'inline', type: 'image/png'
    end
  end
end

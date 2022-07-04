require "rest-client"

class FetchAiringManga
  PATH = "/manga/airing"

  class << self
    def perform
      Rails.cache.fetch("airing-manga") do
        response = RestClient.get(url)
        ids = JSON.parse(response)

        Mangadex::Manga.list(ids: ids, limit: ids.length, includes: [:cover_art])
      end
    end

    private

    def url
      uri = URI(Rails.application.config.x.airing_manga_api_host)
      uri.path = PATH

      uri.to_s
    end
  end
end

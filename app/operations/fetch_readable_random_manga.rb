class FetchReadableRandomManga
  class << self
    def perform(translated_language = nil, from_id: nil)
      found_manga = nil

      if from_id
        result = Rails.cache.read(cache_key(from_id))
        return result if result.present?
      end

      loop do
        result = Mangadex::Manga.random(includes: [:cover_art])

        if result.result == "ok"
          manga = result.data
          chapters = manga.chapters(
            content_rating: manga.content_rating,
            translated_language: Array.wrap(translated_language).compact.map(&:to_s),
          )
          found_manga = Views::ReadableManga.new(manga: manga, chapters: chapters) if chapters.size > 0
        end

        break if found_manga.present?
      end

      write_to_cache(from_id, found_manga) if found_manga
      found_manga
    end

    private

    def cache_key(from_id)
      "readable.#{from_id}"
    end

    def write_to_cache(from_id, readable)
      Rails.cache.write(cache_key(from_id), readable)
    end
  end
end

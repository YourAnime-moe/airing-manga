class FetchReadableRandomManga
  class << self
    def perform(translated_language = nil, from_id: nil)
      found_manga = nil
      tried_to_find = false

      if from_id
        result = Rails.cache.read(cache_key(from_id))
        return result if result.present?
      end

      loop do
        result = if from_id && !tried_to_find
          Mangadex::Manga.view(from_id, includes: [:cover_art])
        else
          Mangadex::Manga.random(includes: [:cover_art])
        end

        if result.result == "ok"
          manga = result.data
          chapters = manga.chapters(
            content_rating: manga.content_rating,
            translated_language: Array.wrap(translated_language).compact.map(&:to_s),
          )
          readable_manga = Views::ReadableManga.new(manga: manga, chapters: chapters)
          found_manga = readable_manga if readable_manga.chapter && readable_manga.chapter.pages.to_i > 0
        end

        break if found_manga.present?
        tried_to_find = true
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

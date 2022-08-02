module Views
  class ReadableManga
    LONG_STRIP_TAG_ID = "3e2b8dae-350e-4ab8-a8ce-016e844b9f0d"

    attr_reader :manga, :chapters, :data_saver

    def initialize(manga:, chapters:, data_saver: true)
      @manga = manga
      @chapters = chapters
      @data_saver = data_saver
    end

    def by
      (@manga.every(:artist) + @manga.every(:author)).uniq do |a|
        a.id
      end
    end

    def chapter
      @chapters.first
    end

    def scanlation_group
      return unless chapter.every(:scanlation_group).any?

      chapter.scanlation_group
    end

    def page_urls
      return @page_urls if @page_urls.present?

      @page_urls = Array.wrap([@manga.cover_art.image_url(size: :original)])
      @page_urls.concat(Array.wrap(chapter.page_urls(data_saver: @data_saver)))

      @page_urls
    end

    def long_strip?
      manga.tags.any? { |tag| tag["id"] == LONG_STRIP_TAG_ID }
    end
  end
end

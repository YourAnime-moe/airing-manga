module Views
  class ReadableManga
    LONG_STRIP_TAG_ID = "3e2b8dae-350e-4ab8-a8ce-016e844b9f0d"

    attr_reader :manga, :chapters, :data_saver

    def initialize(manga:, chapters:, data_saver: true)
      @manga = manga
      @chapters = chapters
      @data_saver = data_saver
    end

    def chapter
      @chapters.first
    end

    def page_urls
      return @page_urls if @page_urls.present?

      @page_urls = [@manga.cover_art.image_url(size: :original)]
      @page_urls.concat(chapter.page_urls(data_saver: @data_saver))

      @page_urls
    end

    def default_options
      {
        "pages" => chapter.pages,
        "current-page" => 0,
        "format" => long_strip? ? "fullwidth" : "fullheight",
      }
    end

    def long_strip?
      manga.tags.any? { |tag| tag["id"] == LONG_STRIP_TAG_ID }
    end
  end
end

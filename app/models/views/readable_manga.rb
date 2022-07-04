module Views
  class ReadableManga
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
  end
end

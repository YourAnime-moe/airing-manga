module Views
  class AiringManga
    attr_reader :manga, :anime

    def initialize(manga:, anime:)
      @manga = manga
      @anime = anime
    end
  end
end

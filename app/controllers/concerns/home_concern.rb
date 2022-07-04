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
  end
end

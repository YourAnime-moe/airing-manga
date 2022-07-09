module HomeHelper
  def reader_container(readable, **override_options, &block)
    options = {
      id: "reader",
      class: "fixed bg-black grid h-screen w-screen gap-2",
      data: {
        "pages" => readable.chapter.pages,
        "current-page" => 0,
        "format" => readable.long_strip? ? "fullwidth" : "fullheight",
      },
    }.merge(override_options)

    content_tag(:div, **options, &block)
  end

  def content_rating_tag(readable)
    content_rating = readable.manga.content_rating

    case content_rating.to_s
    when "safe"
      content_tag(:span, "Safe", class: "tag safe")
    when "suggestive"
      content_tag(:span, "Suggestive", class: "tag suggestive")
    when "erotica"
      content_tag(:span, "Erotica", class: "tag erotica")
    when "pornographic"
      content_tag(:span, "Pornographic (18+)", class: "tag pornographic")
    end
  end

  def publication_demographic_tag(readable)
    publication_demographic = readable.manga.publication_demographic

    case publication_demographic
    when "shounen"
      content_tag(:span, "Shounen", class: "tag")
    when "shoujo"
      content_tag(:span, "Shoujo", class: "tag")
    when "josei"
      content_tag(:span, "Josei", class: "tag")
    when "seinen"
      content_tag(:span, "Seinen", class: "tag")
    end
  end

  def year_tag(readable)
    return if readable.manga.year.blank?

    content_tag(:span, readable.manga.year.to_s, class: "tag")
  end
end

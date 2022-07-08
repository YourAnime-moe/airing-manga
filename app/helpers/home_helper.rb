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
end

module HomeHelper
  def reader_container(readable, **override_options, &block)
    options = {
      id: "reader",
      class: "relative bg-black grid h-screen gap-2",
      data: readable.default_options,
    }.merge(override_options)

    content_tag(:div, **options, &block)
  end
end

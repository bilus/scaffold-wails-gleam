import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn text_field(
  value: String,
  on_input: fn(String) -> msg,
  placeholder: String,
) -> Element(msg) {
  html.input([
    attribute.class(
      "w-full rounded px-2 py-1 text-sm shadow-field border border-mac-border focus:outline-none focus:ring-2 focus:ring-mac-blue/30 bg-white",
    ),
    attribute.type_("text"),
    attribute.value(value),
    attribute.placeholder(placeholder),
    event.on_input(on_input),
  ])
}

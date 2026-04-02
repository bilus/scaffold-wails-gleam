import gleam/int
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn textarea(
  value: String,
  on_input: fn(String) -> msg,
  rows: Int,
  placeholder: String,
) -> Element(msg) {
  html.textarea(
    [
      attribute.class(
        "w-full rounded px-2 py-1.5 text-sm shadow-field border border-mac-border focus:outline-none focus:ring-2 focus:ring-mac-blue/30 bg-white resize-y font-mono",
      ),
      attribute.attribute("rows", int.to_string(rows)),
      attribute.placeholder(placeholder),
      attribute.value(value),
      event.on_input(on_input),
    ],
    "",
  )
}

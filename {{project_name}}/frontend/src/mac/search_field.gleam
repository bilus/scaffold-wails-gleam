import gleam/string
import lustre/attribute.{type Attribute} as attr
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn search_field(
  value: String,
  on_input on_input: fn(String) -> msg,
  on_clear on_clear: msg,
  placeholder placeholder: String,
) -> Element(msg) {
  html.div(
    [attr.class("relative flex items-center")],
    [
      // Magnifying glass icon
      magnifying_glass_icon(),
      // Text input
      html.input(input_attrs(value, on_input, placeholder)),
      // Clear button (visible only when value is non-empty)
      case string.is_empty(value) {
        True -> html.text("")
        False -> clear_button(on_clear)
      },
    ],
  )
}

fn input_attrs(
  value: String,
  on_input: fn(String) -> msg,
  placeholder: String,
) -> List(Attribute(msg)) {
  [
    attr.type_("text"),
    attr.class(
      "w-full rounded-full pl-7 pr-7 py-1 text-sm shadow-field border border-mac-border focus:outline-none focus:ring-2 focus:ring-mac-blue/30 bg-white",
    ),
    attr.value(value),
    attr.placeholder(placeholder),
    event.on_input(on_input),
  ]
}

fn clear_button(on_clear: msg) -> Element(msg) {
  html.button(
    [
      attr.class(
        "absolute right-2 text-mac-text-secondary hover:text-mac-text cursor-default",
      ),
      attr.type_("button"),
      event.on_click(on_clear),
    ],
    [html.text("\u{00D7}")],
  )
}

fn magnifying_glass_icon() -> Element(msg) {
  element.namespaced(
    "http://www.w3.org/2000/svg",
    "svg",
    [
      attr.class("absolute left-2 w-3.5 h-3.5 text-mac-text-secondary"),
      attr.attribute("viewBox", "0 0 20 20"),
      attr.attribute("fill", "currentColor"),
    ],
    [
      element.namespaced(
        "http://www.w3.org/2000/svg",
        "path",
        [
          attr.attribute("fill-rule", "evenodd"),
          attr.attribute(
            "d",
            "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z",
          ),
          attr.attribute("clip-rule", "evenodd"),
        ],
        [],
      ),
    ],
  )
}

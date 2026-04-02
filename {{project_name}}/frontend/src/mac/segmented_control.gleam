import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn segmented_control(
  options: List(String),
  selected: String,
  on_select: fn(String) -> msg,
) -> Element(msg) {
  html.div(
    [
      attribute.class(
        "inline-flex rounded-lg bg-mac-gray-1 p-0.5 shadow-segmented",
      ),
    ],
    list.map(options, fn(option) {
      let is_selected = option == selected
      let button_class =
        "px-3 py-1 text-sm cursor-default transition-all "
        <> case is_selected {
          True -> "bg-white rounded-md shadow-sm font-medium"
          False -> "hover:bg-mac-gray-2 rounded-md"
        }

      html.button(
        [attribute.class(button_class), event.on_click(on_select(option))],
        [html.text(option)],
      )
    }),
  )
}

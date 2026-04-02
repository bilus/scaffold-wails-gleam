import gleam/int
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn sidebar_item(
  label: String,
  count: Int,
  selected: Bool,
  on_click: msg,
) -> Element(msg) {
  let container_class =
    "flex items-center justify-between px-3 py-1 mx-2 rounded cursor-default text-sm "
    <> case selected {
      True -> "bg-mac-blue text-white"
      False -> "hover:bg-mac-gray-1 text-mac-text"
    }

  let badge_class =
    "text-xs rounded-full px-1.5 min-w-[18px] text-center "
    <> case selected {
      True -> "bg-white/30 text-white"
      False -> "bg-mac-gray-2 text-mac-text-secondary"
    }

  html.div(
    [attribute.class(container_class), event.on_click(on_click)],
    [
      html.span([], [html.text(label)]),
      case count > 0 {
        True ->
          html.span(
            [attribute.class(badge_class)],
            [html.text(int.to_string(count))],
          )
        False -> element.none()
      },
    ],
  )
}

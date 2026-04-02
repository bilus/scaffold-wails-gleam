import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn pill_group(
  items: List(String),
  selected: List(String),
  on_toggle: fn(String) -> msg,
) -> Element(msg) {
  html.div(
    [attribute.class("flex flex-wrap gap-1.5")],
    list.map(items, fn(item) {
      let is_selected = list.contains(selected, item)
      let pill_class =
        "rounded-full px-2 py-0.5 text-xs cursor-default transition-colors "
        <> case is_selected {
          True -> "bg-mac-blue text-white"
          False -> "bg-mac-gray-2 text-mac-text hover:bg-mac-gray-3"
        }

      html.span(
        [attribute.class(pill_class), event.on_click(on_toggle(item))],
        [html.text(item)],
      )
    }),
  )
}

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn toolbar(
  left: List(Element(msg)),
  center: List(Element(msg)),
  right: List(Element(msg)),
) -> Element(msg) {
  html.div(
    [
      attribute.class(
        "flex items-center h-12 px-4 border-b border-mac-border bg-white/60 backdrop-blur shrink-0",
      ),
    ],
    [
      html.div([attribute.class("flex items-center gap-2 flex-1")], left),
      html.div([attribute.class("flex items-center gap-2")], center),
      html.div(
        [attribute.class("flex items-center gap-2 flex-1 justify-end")],
        right,
      ),
    ],
  )
}

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn split_view_3(
  left: Element(msg),
  center: Element(msg),
  right: Element(msg),
  left_width: String,
  right_width: String,
) -> Element(msg) {
  html.div(
    [
      attribute.styles([
        #("display", "grid"),
        #(
          "grid-template-columns",
          left_width <> " 1fr " <> right_width,
        ),
        #("height", "100%"),
      ]),
    ],
    [
      // Left pane
      html.div(
        [attribute.class("overflow-y-auto border-r border-mac-border")],
        [left],
      ),
      // Center pane
      html.div(
        [attribute.class("overflow-y-auto border-r border-mac-border")],
        [center],
      ),
      // Right pane
      html.div([attribute.class("overflow-y-auto")], [right]),
    ],
  )
}

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn disclosure(
  header: Element(msg),
  body: Element(msg),
  expanded: Bool,
  on_toggle: msg,
) -> Element(msg) {
  html.div([], [
    // Header row
    html.div(
      [
        attribute.class("flex items-center cursor-default"),
        event.on_click(on_toggle),
      ],
      [
        html.span(
          [
            attribute.class("text-xs text-mac-text-secondary mr-1.5 inline-block"),
            attribute.style([#("transform", case expanded {
              True -> "rotate(90deg)"
              False -> "rotate(0deg)"
            }), #("transition", "transform 0.15s ease")]),
          ],
          [html.text("\u{25B6}")],
        ),
        header,
      ],
    ),
    // Body
    html.div(
      case expanded {
        True -> []
        False -> [attribute.class("hidden")]
      },
      [body],
    ),
  ])
}

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn empty_state(title: String, subtitle: String) -> Element(msg) {
  html.div(
    [
      attribute.class(
        "flex flex-col items-center justify-center py-12 text-center",
      ),
    ],
    [
      html.div(
        [attribute.class("text-lg font-medium text-mac-text-secondary")],
        [html.text(title)],
      ),
      html.div(
        [attribute.class("text-sm text-mac-text-secondary mt-1")],
        [html.text(subtitle)],
      ),
    ],
  )
}

import lustre/attribute as attr
import lustre/element.{type Element}
import lustre/element/html

pub fn form_row(label label: String, child child: Element(msg)) -> Element(msg) {
  html.div(
    [attr.class("flex items-start gap-3 py-1.5")],
    [
      html.label(
        [
          attr.class(
            "w-28 text-right text-sm text-mac-text-secondary pt-1 shrink-0",
          ),
        ],
        [html.text(label)],
      ),
      html.div([attr.class("flex-1")], [child]),
    ],
  )
}

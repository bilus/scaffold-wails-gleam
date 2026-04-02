import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn badge(label: String, bg: String, fg: String) -> Element(msg) {
  html.span(
    [
      attribute.class(
        "inline-block rounded-full px-2 py-0.5 text-xs font-medium",
      ),
      attribute.styles([#("background-color", bg), #("color", fg)]),
    ],
    [html.text(label)],
  )
}

pub fn scope_badge(scope: String) -> Element(msg) {
  case scope {
    "api" -> badge(scope, "#dbeafe", "#1d4ed8")
    "oem" -> badge(scope, "#dcfce7", "#15803d")
    "sdk" -> badge(scope, "#f3e8ff", "#7e22ce")
    _ -> badge(scope, "#f3f4f6", "#374151")
  }
}

pub fn label_badge(text: String) -> Element(msg) {
  badge(text, "#f3f4f6", "#374151")
}

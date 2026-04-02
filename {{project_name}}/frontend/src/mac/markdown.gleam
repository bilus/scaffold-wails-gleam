import gleam/json
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

@external(javascript, "../markdown_ffi.mjs", "renderMarkdown")
fn render_markdown(source: String) -> String

pub fn markdown(source: String) -> Element(msg) {
  let html_content = render_markdown(source)
  html.div(
    [
      attribute.class("mac-markdown text-sm leading-relaxed"),
      attribute.property("innerHTML", json.string(html_content)),
    ],
    [],
  )
}

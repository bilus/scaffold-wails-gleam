import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import mac/markdown
import mac/textarea

pub fn markdown_editor(
  value: String,
  on_input: fn(String) -> msg,
  placeholder: String,
) -> Element(msg) {
  html.div(
    [attribute.class("flex gap-2 min-h-[120px]")],
    [
      html.div(
        [attribute.class("flex-1")],
        [textarea.textarea(value, on_input, 6, placeholder)],
      ),
      html.div(
        [
          attribute.class(
            "flex-1 overflow-y-auto rounded border border-mac-border p-2 bg-white",
          ),
        ],
        [markdown.markdown(value)],
      ),
    ],
  )
}

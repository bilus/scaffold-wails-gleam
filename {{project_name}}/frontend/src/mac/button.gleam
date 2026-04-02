import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn primary(label: String, on_click: msg) -> Element(msg) {
  html.button(
    [
      attribute.class(
        "rounded bg-gradient-to-b from-mac-blue-dark to-mac-blue py-[1.5px] px-3 text-sm text-white shadow-md active:brightness-110 cursor-default",
      ),
      event.on_click(on_click),
    ],
    [html.text(label)],
  )
}

pub fn secondary(label: String, on_click: msg) -> Element(msg) {
  html.button(
    [
      attribute.class(
        "rounded py-[1.5px] px-3 text-sm shadow-sm active:bg-mac-gray-1 cursor-default",
      ),
      event.on_click(on_click),
    ],
    [html.text(label)],
  )
}

pub fn icon_button(
  children: List(Element(msg)),
  on_click: msg,
) -> Element(msg) {
  html.button(
    [
      attribute.class(
        "rounded-full p-1 hover:bg-mac-gray-2 active:bg-mac-gray-3 cursor-default",
      ),
      event.on_click(on_click),
    ],
    children,
  )
}

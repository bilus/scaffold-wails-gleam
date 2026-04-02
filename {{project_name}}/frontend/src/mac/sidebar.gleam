import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn sidebar(children: List(Element(msg))) -> Element(msg) {
  html.nav(
    [
      attribute.class(
        "w-[220px] h-full bg-mac-bg backdrop-blur-xl border-r border-mac-border overflow-y-auto flex flex-col shrink-0",
      ),
    ],
    children,
  )
}

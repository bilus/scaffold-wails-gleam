import gleam/list
import lustre/attribute as attr
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn mac_select(
  options options: List(#(String, String)),
  selected selected: String,
  on_change on_change: fn(String) -> msg,
) -> Element(msg) {
  html.div(
    [attr.class("relative inline-block")],
    [
      html.select(
        [
          attr.class(
            "appearance-none rounded py-1 pl-2 pr-6 text-sm shadow-sm border border-mac-border bg-white cursor-default focus:outline-none focus:ring-2 focus:ring-mac-blue/30",
          ),
          event.on_change(on_change),
        ],
        list.map(options, fn(opt) {
          let #(val, label) = opt
          html.option(
            [attr.value(val), attr.selected(val == selected)],
            label,
          )
        }),
      ),
      // Chevron indicator
      chevron_icon(),
    ],
  )
}

fn chevron_icon() -> Element(msg) {
  html.div(
    [
      attr.class(
        "pointer-events-none absolute inset-y-0 right-1 flex items-center text-mac-text-secondary",
      ),
    ],
    [
      element.namespaced(
        "http://www.w3.org/2000/svg",
        "svg",
        [
          attr.class("w-3 h-3"),
          attr.attribute("viewBox", "0 0 20 20"),
          attr.attribute("fill", "currentColor"),
        ],
        [
          element.namespaced(
            "http://www.w3.org/2000/svg",
            "path",
            [
              attr.attribute("fill-rule", "evenodd"),
              attr.attribute(
                "d",
                "M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z",
              ),
              attr.attribute("clip-rule", "evenodd"),
            ],
            [],
          ),
        ],
      ),
    ],
  )
}

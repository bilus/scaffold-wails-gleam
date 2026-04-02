import lustre
import lustre/element.{text}
import lustre/element/html.{div, h1, p}

pub fn main() {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view() {
  div([], [
    h1([], [text("Hello, World!")]),
    p([], [text("{{app_title}} is running.")]),
  ])
}

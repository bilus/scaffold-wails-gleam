export function renderMarkdown(source) {
  if (typeof marked !== "undefined" && source) {
    return marked.parse(source);
  }
  return source || "";
}

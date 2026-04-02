// Tailwind CSS configuration for macOS-native styling.
// This file is for reference/documentation. The actual config is inlined
// in index.html for use with the Tailwind CDN approach.
//
// Based on https://github.com/anater/macos-tailwind

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "-apple-system",
          "BlinkMacSystemFont",
          "system-ui",
          "sans-serif",
        ],
      },
      fontSize: {
        xs: "0.625rem",
        sm: "0.6875rem",
        base: "0.8125rem",
        lg: "0.875rem",
        xl: "1rem",
      },
      colors: {
        "mac-blue": "#007AFF",
        "mac-blue-dark": "#0058D0",
        "mac-gray-1": "rgba(0,0,0,0.04)",
        "mac-gray-2": "rgba(0,0,0,0.07)",
        "mac-gray-3": "rgba(0,0,0,0.1)",
        "mac-gray-4": "rgba(0,0,0,0.14)",
        "mac-gray-5": "rgba(0,0,0,0.2)",
        "mac-bg": "rgba(246,246,246,0.8)",
        "mac-text": "#1d1d1f",
        "mac-text-secondary": "#86868b",
        "mac-border": "rgba(0,0,0,0.1)",
        "mac-selection": "rgba(0,122,255,0.15)",
      },
      boxShadow: {
        field:
          "0 0 0 0.5px rgba(0,0,0,0.12), 0 1px 1px rgba(0,0,0,0.04)",
        menu: "0 10px 38px -10px rgba(0,0,0,0.35), 0 10px 20px -15px rgba(0,0,0,0.2)",
        segmented: "0 1px 3px rgba(0,0,0,0.08)",
      },
    },
  },
};

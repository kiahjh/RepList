import SwiftUI

public extension Color {
  init?(hex: String) {
    let r, g, b: Double

    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)

    switch hexSanitized.count {
    case 3: // RGB
      (r, g, b) = (
        Double((rgb >> 8) & 0xF) / 15.0,
        Double((rgb >> 4) & 0xF) / 15.0,
        Double(rgb & 0xF) / 15.0
      )
    case 6: // RRGGBB
      (r, g, b) = (
        Double((rgb >> 16) & 0xFF) / 255.0,
        Double((rgb >> 8) & 0xFF) / 255.0,
        Double(rgb & 0xFF) / 255.0
      )
    default:
      return nil
    }

    self.init(red: r, green: g, blue: b)
  }

  init(_ colorScheme: ColorScheme, light: Color, dark: Color) {
    if colorScheme == .dark {
      self.init(dark)
    } else {
      self.init(light)
    }
  }
}
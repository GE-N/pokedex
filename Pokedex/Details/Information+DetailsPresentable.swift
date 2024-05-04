import Foundation

extension InformationResponse {
  /**
   Return official image url. If not have will return a default sprite image instead.
  */
  func officialArtworkUrl() -> URL? {
    guard let officialArtwork = sprites.other?["official-artwork"]?.frontDefault else {
      let defaultUrl = sprites.frontDefault ?? ""
      return URL(string: defaultUrl)
    }
    return URL(string: officialArtwork)
  }
  
  func pokemonStats() -> StatViewItem {
    let statItem = StatViewItem()
    stats.forEach { item in
      switch item.stat.name {
      case "hp": statItem.hp = item.baseStat
      case "attack": statItem.atk = item.baseStat
      case "defense": statItem.def = item.baseStat
      case "special-attack": statItem.sAtk = item.baseStat
      case "special-defense": statItem.sDef = item.baseStat
      case "speed": statItem.spd = item.baseStat
      default:
        break
      }
    }
    return statItem
  }
}

extension SpeciesResponse {
  /// First en text by order, ignore version.
  func defaultFlavorText() -> String {
    return flavorTextEntries.filter { $0.language.name == "en" }.first?.flavorText.replacingOccurrences(of: "\n", with: " ") ?? ""
  }
}

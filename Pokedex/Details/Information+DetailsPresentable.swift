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

extension TypeResponse: TypeViewPresentable {
  var types: String {
    return name
  }
  
  var doubleDamageFrom: String? {
    return damageRelations.doubleDamageFrom.map { $0.name }.joined(separator: ", ")
  }
  
  var doubleDamageTo: String? {
    return damageRelations.doubleDamageTo.map { $0.name }.joined(separator: ", ")
  }
  
  var halfDamageFrom: String? {
    return damageRelations.halfDamageFrom.map { $0.name }.joined(separator: ", ")
  }
  
  var halfDamageTo: String? {
    return damageRelations.halfDamageTo.map { $0.name }.joined(separator: ", ")
  }
  
  var noDamageFrom: String? {
    return damageRelations.noDamageFrom.map { $0.name }.joined(separator: ", ")
  }
  
  var noDamageTo: String? {
    return damageRelations.noDamageTo.map { $0.name }.joined(separator: ", ")
  }
}

extension AbilityResponse: AbilityViewPresentable {
  var details: String {
    let defaultTextEntry = flavorTextEntries.filter { $0.language.name == "en" }.first?.flavorText ?? ""
    return defaultTextEntry.replacingOccurrences(of: "\n", with: " ")
  }
}

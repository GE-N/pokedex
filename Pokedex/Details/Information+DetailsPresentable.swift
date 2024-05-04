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
}

import Foundation

struct InformationResponse: Decodable {
  let id: Int
  let name: String
  let sprites: Sprite
  let stats: [Stat]
  let species: RetrievableValue
}

// MARK: Profile image

struct Sprite: Decodable {
  let frontDefault: String?
  let other: [String: Sprite]?
}

// MARK: - Stats

struct Stat: Decodable {
  let baseStat: Int
  let stat: RetrievableValue
}

// MARK: - Species response

struct SpeciesResponse: Decodable {
  let flavorTextEntries: [TextEntry]
}

struct TextEntry: Decodable {
  let flavorText: String
  let language: RetrievableValue
  let version: RetrievableValue
}

import Foundation

struct InformationResponse: Decodable {
  let id: Int
  let name: String
  let sprites: Sprite
  let stats: [Stat]
}

// ---

struct Sprite: Decodable {
  let frontDefault: String?
  let other: [String: Sprite]?
}

struct Stat: Decodable {
  let baseStat: Int
  let stat: RetrievableValue
}

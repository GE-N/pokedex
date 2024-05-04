import Foundation

struct InformationResponse: Decodable {
  let id: Int
  let name: String
  let sprites: Sprite
}

// ---

struct Sprite: Decodable {
  let frontDefault: String?
  let other: [String: Sprite]?
}

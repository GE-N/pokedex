import Foundation

struct InformationResponse: Decodable {
  let id: Int
  let name: String
  let sprites: Sprite
  let stats: [Stat]
  let species: RetrievableValue
  let types: [CharacterType]
  let abilities: [Ability]
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

// MARK: - Types

struct CharacterType: Decodable {
  let name: String
  let url: String
  
  enum CodingKeys: CodingKey {
    case type
  }
  
  enum TypeCodingKeys: CodingKey {
    case name
    case url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let typeContainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
    self.name = try typeContainer.decode(String.self, forKey: .name)
    self.url = try typeContainer.decode(String.self, forKey: .url)
  }
}


// MARK: - Ability

struct Ability: Decodable {
  let ability: RetrievableValue
  let isHidden: Bool
}

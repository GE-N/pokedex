import Foundation

struct GetAllPokemonResponse: Decodable {
  let results: [Pokemon]
}

struct Pokemon: Decodable {
  let id: String
  let name: String
  let url: String
  
  enum CodingKeys: CodingKey {
    case name
    case url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(String.self, forKey: .url)
    let path = URLComponents(string: url)?.path
    let idFromPath = path?.components(separatedBy: "/").filter { !$0.isEmpty }.last
    self.id = idFromPath ?? UUID().uuidString
  }
}

extension Pokemon: HomeCellPresentable {
  var imageUrl: URL? {
    let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    return url
  }
}

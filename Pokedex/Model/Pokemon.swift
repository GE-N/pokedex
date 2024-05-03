import Foundation

struct Pokemon {
  let id: String
  let name: String
}

extension Pokemon: HomeCellPresentable {
  var imageUrl: URL? {
    let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    return url
  }
}

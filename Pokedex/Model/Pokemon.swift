import Foundation

struct GetAllPokemonResponse: Decodable {
  let results: [Pokemon]
}

final class Pokemon: RetrievableValue {}

extension Pokemon: HomeCellPresentable {
  var id: String {
    let path = URLComponents(string: url)?.path
    let idFromPath = path?.components(separatedBy: "/").filter { !$0.isEmpty }.last
    return idFromPath ?? UUID().uuidString
  }
  
  var imageUrl: URL? {
    let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    return url
  }
}

extension Pokemon: DetailsRetrievable {
  var infoApi: URL? {
    return URL(string: url)
  }
}

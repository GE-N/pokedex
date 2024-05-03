struct HomeSection {
  var items: [HomeItem]
  var name: String = ""
  
  init(items: [HomeItem], name: String) {
    self.items = items
    self.name = name
  }
}

extension HomeSection: Equatable {}

extension HomeSection: Hashable {}

enum HomeItem {
  case item(Pokemon)
}

extension HomeItem: Equatable {
  static func == (lhs: HomeItem, rhs: HomeItem) -> Bool {
    switch (lhs, rhs) {
    case let (item(lhs), item(rhs)):
      return lhs.id == rhs.id
    }
  }
}

extension HomeItem: Hashable {
  func hash(into hasher: inout Hasher) {
    switch self {
    case let .item(pokemon):
      hasher.combine(pokemon.id)
    }
  }
}

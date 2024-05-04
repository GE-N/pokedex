protocol DetailsViewModelInput {
  
}

protocol DetailsViewModelOutput {
  var name: String { get }
}

protocol DetailsViewModel {
  var input: DetailsViewModelInput { get }
  var output: DetailsViewModelOutput { get }
}

final class DetailsViewModelImpl: DetailsViewModel, DetailsViewModelInput, DetailsViewModelOutput {
  var input: DetailsViewModelInput { self }
  var output: DetailsViewModelOutput { self }
  
  var name: String
  
  init(pokemon: Pokemon) {
    name = pokemon.name.capitalized
  }
}

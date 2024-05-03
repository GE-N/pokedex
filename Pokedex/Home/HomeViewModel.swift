import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
}

protocol HomeViewModelOutput {
  var sections: Driver<[HomeSection]> { get }
}

protocol HomeViewModel {
  var input: HomeViewModelInput { get }
  var output: HomeViewModelOutput { get }
}

final class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {
  var input: HomeViewModelInput { self }
  var output: HomeViewModelOutput { self }
  
  let viewDidLoad: PublishRelay<Void> = .init()
  
  var sections: Driver<[HomeSection]> = .empty()
  
  init() {
    let api = APIRequest()
    sections = viewDidLoad
      .flatMap { _ -> Observable<GetAllPokemonResponse> in
        api.request(.getAllPokemon)
      }
      .map { items in
        let homeItems = items.results.map { HomeItem.item($0) }
        let section = HomeSection(items: homeItems, name: "main")
        return [section]
      }
      .asDriver(onErrorJustReturn: [])
    
    // TODO: Handle presentation on load fail
  }
}

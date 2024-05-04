import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var filterTyped: BehaviorRelay<String> { get }
  var itemSelected: PublishRelay<IndexPath> { get }
}

protocol HomeViewModelOutput {
  var sections: Driver<[HomeSection]> { get }
  var canClearSearchBox: Driver<Bool> { get }
  var showInfo: Driver<Pokemon> { get }
}

protocol HomeViewModel {
  var input: HomeViewModelInput { get }
  var output: HomeViewModelOutput { get }
}

final class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {
  var input: HomeViewModelInput { self }
  var output: HomeViewModelOutput { self }
  
  let viewDidLoad: PublishRelay<Void> = .init()
  let filterTyped: BehaviorRelay<String> = .init(value: "")
  let itemSelected: PublishRelay<IndexPath> = .init()
  
  var sections: Driver<[HomeSection]> = .empty()
  var canClearSearchBox: Driver<Bool> = .empty()
  var showInfo: Driver<Pokemon> = .empty()
  
  private let bag = DisposeBag()
  
  init() {
    let api = APIRequest()
    
    let allPokemon: BehaviorSubject<[Pokemon]> = .init(value: [])
    
    viewDidLoad
      .flatMap { _ -> Observable<GetAllPokemonResponse> in
        api.request(.getAllPokemon)
      }
      .map { $0.results }
      .bind(to: allPokemon)
      .disposed(by: bag)
    
    // TODO: Handle presentation on load fail
    
    let filterByKeyword = filterTyped.withLatestFrom(allPokemon) { keyword, pokemons in
      guard !keyword.isEmpty else { return pokemons }
      
      if let _ = Int(keyword) {
        return pokemons.filter { $0.id == keyword }
      }
      
      return pokemons.filter { pokemon in
        pokemon.name.contains(keyword.lowercased())
      }
    }
    
    sections = Observable.merge(allPokemon, filterByKeyword)
      .map { items in
        let homeItems = items.map { HomeItem.item($0) }
        let section = HomeSection(items: homeItems, name: "main")
        return [section]
      }
      .asDriver(onErrorJustReturn: [])
    
    canClearSearchBox = filterTyped
      .map { !$0.isEmpty }
      .asDriver(onErrorJustReturn: false)
    
    showInfo = itemSelected.withLatestFrom(sections) { index, section -> Pokemon in
      guard let selectedItem = section.first?.items[index.row],
            let itemValue: Pokemon = selectedItem.value() else {
        throw "invalid item selection"
      }
      return itemValue
    }
    .asDriver(onErrorDriveWith: .empty())
  }
}

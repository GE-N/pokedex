import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var filterTyped: BehaviorRelay<String> { get }
  var itemSelected: PublishRelay<IndexPath> { get }
  var retryDidTap: PublishRelay<Void> { get }
}

protocol HomeViewModelOutput {
  var sections: Driver<[HomeSection]> { get }
  var canClearSearchBox: Driver<Bool> { get }
  var showInfo: Driver<Pokemon> { get }
  var loadResult: Driver<Result<Void, Error>> { get }
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
  let retryDidTap: PublishRelay<Void> = .init()
  
  var sections: Driver<[HomeSection]> = .empty()
  var canClearSearchBox: Driver<Bool> = .empty()
  var showInfo: Driver<Pokemon> = .empty()
  var loadResult: Driver<Result<Void, Error>> = .empty()
  
  private let bag = DisposeBag()
  
  init() {
    let api = APIRequest()
    
    let allPokemon: BehaviorSubject<[Pokemon]> = .init(value: [])
    
    let getAllItems = Observable.merge(
      viewDidLoad.asObservable(),
      retryDidTap.asObservable()
    )
    .flatMap { _ -> Observable<Event<GetAllPokemonResponse>> in
      api.request(.getAllPokemon).materialize()
    }
    .share()
    
    getAllItems
      .values()
      .map { $0.results }
      .bind(to: allPokemon)
      .disposed(by: bag)
    
    // MARK: - Filter
    
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
    
    // MARK: - Error handling
    
    let getAllItemSuccess = getAllItems.values().map { _ -> Result<Void, Error> in .success(()) }
    let getAllItemFailed = getAllItems.errors().map { error -> Result<Void, Error> in .failure(error) }
    loadResult = Observable.merge(getAllItemSuccess, getAllItemFailed).asDriver(onErrorJustReturn: .failure(""))
  }
}

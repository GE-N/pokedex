import Foundation
import RxSwift
import RxCocoa

protocol DetailsViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
  var retryDidTap: PublishRelay<Void> { get }
}

protocol DetailsViewModelOutput {
  var name: String { get }
  var imageUrl: Driver<URL?> { get }
  var stats: Driver<StatViewItem> { get }
  var speciesDescription: Driver<String> { get }
  var types: Driver<[TypeResponse]> { get }
  var abilities: Driver<[AbilityResponse]> { get }
  var loading: Driver<Void> { get }
  var loadResult: Driver<Result<Void, Error>> { get }
}

protocol DetailsViewModel {
  var input: DetailsViewModelInput { get }
  var output: DetailsViewModelOutput { get }
}

final class DetailsViewModelImpl: DetailsViewModel, DetailsViewModelInput, DetailsViewModelOutput {
  var input: DetailsViewModelInput { self }
  var output: DetailsViewModelOutput { self }
  
  let viewDidLoad: PublishRelay<Void> = .init()
  let retryDidTap: PublishRelay<Void> = .init()
  
  var name: String
  var imageUrl: Driver<URL?> = .empty()
  var stats: Driver<StatViewItem> = .empty()
  var speciesDescription: Driver<String> = .empty()
  var types: Driver<[TypeResponse]> = .empty()
  var abilities: Driver<[AbilityResponse]> = .empty()
  var loading: Driver<Void> = .empty()
  var loadResult: Driver<Result<Void, Error>> = .empty()
  
  private let bag = DisposeBag()
  
  init(pokemon: DetailsRetrievable) {
    let api = APIRequest()
    name = pokemon.name.capitalized
    
    let loadingState = PublishRelay<Void>()
    loading = loadingState.asDriver(onErrorDriveWith: .empty())
    
    let infoResponse = Observable.merge(viewDidLoad.asObservable(), retryDidTap.asObservable())
      .flatMap { _ -> Observable<Event<InformationResponse>> in
        loadingState.accept(())
        guard let getInfoApi = pokemon.infoApi else { return .empty() }
        return api.request(.custom(getInfoApi)).materialize()
      }
      .share()
    
    let infoResponseSuccess = infoResponse.values().share()
    
    imageUrl = infoResponseSuccess
      .map { $0.officialArtworkUrl() }
      .asDriver(onErrorJustReturn: nil)
    
    stats = infoResponseSuccess
      .map { $0.pokemonStats() }
      .asDriver(onErrorJustReturn: StatViewItem())
    
    speciesDescription = infoResponseSuccess.flatMap { info -> Observable<SpeciesResponse> in
      guard let speciesInfo = URL(string: info.species.url) else { return .empty() }
      return api.request(.custom(speciesInfo))
    }
    .map { $0.defaultFlavorText() }
    .asDriver(onErrorJustReturn: "")
    
    // MARK: - Types
    
    types = infoResponseSuccess
      .map { $0.types }
      .flatMapLatest { types in
        Observable.from(types).flatMap { type -> Observable<TypeResponse> in
          guard let url = URL(string: type.url) else { return .empty() }
          return api.request(.custom(url))
        }
      }
      .map { [$0] }
      .asDriver(onErrorJustReturn: [])
    
    // MARK: - Abilities
    
    abilities = infoResponseSuccess
      .map { $0.abilities.filter { $0.isHidden == false } }
      .flatMapLatest { abilities in
        Observable.from(abilities).flatMap { item -> Observable<AbilityResponse> in
          guard let url = URL(string: item.ability.url) else { return .empty() }
          return api.request(.custom(url))
        }
      }
      .map { [$0] }
      .asDriver(onErrorJustReturn: [])
    
    let allSections = Observable.combineLatest(
      imageUrl.asObservable(),
      stats.asObservable(),
      speciesDescription.asObservable(),
      types.asObservable(),
      abilities.asObservable()
    )
    let allSectionSuccess = allSections.map { _ -> Result<Void, Error> in Result.success(()) }
    
    let infoResponseFail = infoResponse.errors().map { error -> Result<Void, Error> in Result.failure(error) }
    
    loadResult = Observable.merge(allSectionSuccess, infoResponseFail)
      .asDriver(onErrorJustReturn: Result.failure("load details fail"))
  }
}

import Foundation
import RxSwift
import RxCocoa

protocol DetailsViewModelInput {
  var viewDidLoad: PublishRelay<Void> { get }
}

protocol DetailsViewModelOutput {
  var name: String { get }
  var imageUrl: Driver<URL?> { get }
}

protocol DetailsViewModel {
  var input: DetailsViewModelInput { get }
  var output: DetailsViewModelOutput { get }
}

final class DetailsViewModelImpl: DetailsViewModel, DetailsViewModelInput, DetailsViewModelOutput {
  var input: DetailsViewModelInput { self }
  var output: DetailsViewModelOutput { self }
  
  let viewDidLoad: PublishRelay<Void> = .init()
  
  var imageUrl: Driver<URL?> = .empty()
  var name: String
  
  private let bag = DisposeBag()
  
  init(pokemon: DetailsRetrievable) {
    let api = APIRequest()
    name = pokemon.name.capitalized
    
    let infoResponse = viewDidLoad.flatMap { _ -> Observable<Event<InformationResponse>> in
      guard let getInfoApi = pokemon.infoApi else { return .empty() }
      return api.request(.custom(getInfoApi)).materialize()
    }.share()
    
    // TODO: handle error
    infoResponse.errors().subscribe(onNext: { error in print(error)}).disposed(by: bag)
    
    let infoResponseSuccess = infoResponse.values().share()
    
    imageUrl = infoResponseSuccess.map { info -> URL? in
      guard let officialArtwork = info.sprites.other?["official-artwork"]?.frontDefault else {
        let defaultUrl = info.sprites.frontDefault ?? ""
        return URL(string: defaultUrl)
      }
      return URL(string: officialArtwork)
    }
    .asDriver(onErrorDriveWith: .empty())
  }
}

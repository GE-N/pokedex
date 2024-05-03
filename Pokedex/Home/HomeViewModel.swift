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
    sections = viewDidLoad.map({ _ -> [HomeSection] in
      let items: [HomeItem] = [
        .item(Pokemon(id: "1", name: "tatsugiri")),
        .item(Pokemon(id: "2", name: "tatsugiri")),
        .item(Pokemon(id: "3", name: "tatsugiri")),
        .item(Pokemon(id: "4", name: "tatsugiri")),
        .item(Pokemon(id: "5", name: "tatsugiri")),
        .item(Pokemon(id: "6", name: "tatsugiri")),
        .item(Pokemon(id: "7", name: "tatsugiri")),
        .item(Pokemon(id: "8", name: "tatsugiri")),
        .item(Pokemon(id: "9", name: "tatsugiri")),
        .item(Pokemon(id: "10", name: "tatsugiri")),
        .item(Pokemon(id: "11", name: "tatsugiri")),
        .item(Pokemon(id: "12", name: "tatsugiri")),
        .item(Pokemon(id: "13", name: "tatsugiri")),
      ]
      let section = HomeSection(items: items, name: "MainSection")
      return [section]
    }).asDriver(onErrorDriveWith: .empty())
  }
}

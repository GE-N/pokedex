import Foundation
import RxSwift

enum API {
  // NOTE: get all items instead partial by paging for compatible search feature. Response only ~80kb will be acceptable.
  case getAllPokemon
  case custom(URL)
  
  var path: String {
    switch self {
    case .getAllPokemon:
      return "pokemon?offset=0&limit=1500"
    default:
      return ""
    }
  }
  
  func request() -> URLRequest {
    switch self {
    case let .custom(url):
      return URLRequest(url: url)
    default:
      let host = "https://pokeapi.co/api/v2/"
      guard let url = URL(string: "\(host)/\(self.path)") else {
        fatalError("API: invalid url")
      }
      return URLRequest(url: url)
    }
  }
}

class APIRequest {
  func request<T: Decodable>(_ api: API) async throws -> T {
    do {
      let (data, response) = try await URLSession.shared.data(for: api.request())
      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
        throw "api \(response.url?.absoluteString ?? "") request failed by return code \(response.statusCode)"
      }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let items = try decoder.decode(T.self, from: data)
      return items
    } catch {
      throw error
    }
  }
  
  func request<T: Decodable>(_ api: API) -> Observable<T> {
    return Observable.create { [unowned self] observer in
      let task = Task {
        do {
          observer.onNext(try await request(api))
          observer.onCompleted()
        } catch {
          observer.onError(error)
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
  }
}

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidLoad))
  }
  
  func controlEvent(selector: Selector) -> ControlEvent<Void> {
    let source = methodInvoked(selector).map { _ in () }
    return ControlEvent(events: source)
  }
}

extension ObservableType where Element: EventConvertible {
    public func values() -> Observable<Element.Element> {
        return compactMap { $0.event.element }
    }

    public func errors() -> Observable<Swift.Error> {
        return compactMap { $0.event.error }
    }
}

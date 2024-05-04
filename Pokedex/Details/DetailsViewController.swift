import UIKit
import RxSwift
import RxCocoa
import Kingfisher

protocol DetailsRetrievable {
  var name: String { get }
  var infoApi: URL? { get }
}

final class DetailsViewController: UIViewController {
  var viewModel: DetailsViewModel!
  private let bag = DisposeBag()
  
  private lazy var pokemonImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var statStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.backgroundColor = .blue
    return stackView
  }()
  
  private lazy var imageAndStatSection: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    stackView.addArrangedSubview(pokemonImageView)
    stackView.addArrangedSubview(statStackView)
    return stackView
  }()
  
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(imageAndStatSection)
    
    return stackView
  }()
  
  private lazy var contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
    ])
    return scrollView
  }()
  
  convenience init(viewModel: DetailsViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  override func loadView() {
    super.loadView()
    setupLayout()
    
    bindInput()
    bindOutput()
  }
  
  private func setupLayout() {
    view.backgroundColor = .white
    
    view.addSubview(contentScrollView)
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  func bindInput() {
    rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
  }
  
  func bindOutput() {
    title = viewModel.output.name
    
    viewModel.output.imageUrl.drive(onNext: { [weak self] url in
      self?.pokemonImageView.kf.setImage(with: url)
    }).disposed(by: bag)
  }
}

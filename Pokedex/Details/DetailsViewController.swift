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
  private let style = Style()
  private let bag = DisposeBag()
  
  private lazy var pokemonImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    let height = view.bounds.size.width / 2
    imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    return imageView
  }()
  
  private lazy var statsView: StatsView = {
    let view = StatsView()
    return view
  }()
  
  private lazy var imageAndStatSection: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    stackView.addArrangedSubview(pokemonImageView)
    stackView.addArrangedSubview(statsView)
    return stackView
  }()
  
  private lazy var speciesDescLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var speciesDescView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(speciesDescLabel)
    NSLayoutConstraint.activate([
      speciesDescLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      speciesDescLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      speciesDescLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
      speciesDescLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
    ])
    view.backgroundColor = style.lightGrayColor
    view.layer.cornerRadius = 8
    return view
  }()
  
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 8
    
    stackView.addArrangedSubview(imageAndStatSection)
    stackView.addArrangedSubview(speciesDescView)
    
    return stackView
  }()
  
  private lazy var contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
      contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
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
    
    speciesDescView.isHidden = true
  }
  
  func bindInput() {
    rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
  }
  
  func bindOutput() {
    title = viewModel.output.name
    
    viewModel.output.imageUrl.drive(onNext: { [weak self] url in
      self?.pokemonImageView.kf.setImage(with: url)
    }).disposed(by: bag)
    
    viewModel.output.stats.drive(onNext: { [weak self] stat in
      self?.statsView.setStats(stat)
    }).disposed(by: bag)
    
    viewModel.output.speciesDescription.drive(onNext: { [weak self] description in
      self?.speciesDescView.isHidden = description.isEmpty
      self?.speciesDescLabel.text = description
    }).disposed(by: bag)
  }
}

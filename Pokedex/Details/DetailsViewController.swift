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
    stackView.spacing = style.padding
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
      speciesDescLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: style.padding),
      speciesDescLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: style.padding),
      speciesDescLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -style.padding),
      speciesDescLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -style.padding),
    ])
    view.backgroundColor = style.lightGrayColor
    view.layer.cornerRadius = style.cornerRadius
    return view
  }()
  
  private lazy var typeViewBox: TypeViewBox = {
    let view = TypeViewBox()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var abilityViewBox: AbilityViewBox = {
    let view = AbilityViewBox()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = style.padding * 2
    
    stackView.addArrangedSubview(imageAndStatSection)
    stackView.addArrangedSubview(speciesDescView)
    stackView.addArrangedSubview(typeViewBox)
    stackView.addArrangedSubview(abilityViewBox)
    
    return stackView
  }()
  
  private lazy var contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: style.padding * 2),
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: style.padding * 2),
      contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      
      contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: style.padding * 2),
      contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -style.padding * 2),
    ])
    return scrollView
  }()
  
  private lazy var loadingView: UIView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = style.padding
    stackView.widthAnchor.constraint(equalToConstant: style.loadingViewWidth).isActive = true
    
    let loadingIndicator = UIActivityIndicatorView()
    loadingIndicator.style = .large
    loadingIndicator.startAnimating()
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = style.subTextFont
    label.text = "Getting Pokemon's information..."
    
    stackView.addArrangedSubview(loadingIndicator)
    stackView.addArrangedSubview(label)
    return stackView
  }()
  
  private lazy var retryView: RetryView = {
    let retryView = RetryView()
    retryView.translatesAutoresizingMaskIntoConstraints = false
    return retryView
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
    
    view.addSubview(loadingView)
    NSLayoutConstraint.activate([
      loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    view.addSubview(retryView)
    NSLayoutConstraint.activate([
      retryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      retryView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    loadingView.isHidden = false
    speciesDescView.isHidden = true
    typeViewBox.isHidden = true
    abilityViewBox.isHidden = true
    contentScrollView.isHidden = true
  }
  
  func bindInput() {
    rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
    retryView.retryButton.rx.tap.bind(to: viewModel.input.retryDidTap).disposed(by: bag)
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
    
    viewModel.output.types.drive(onNext: { [weak self] types in
      types.forEach { type in
        self?.typeViewBox.isHidden = false
        let view = TypesView()
        view.setTypes(item: type)
        self?.typeViewBox.addTypeView(view)
      }
    }).disposed(by: bag)
    
    viewModel.output.abilities.drive(onNext: { [weak self] ability in
      ability.forEach { ability in
        self?.abilityViewBox.isHidden = false
        let view = AbilityView()
        view.setAbility(ability)
        self?.abilityViewBox.addAbility(view)
      }
    }).disposed(by: bag)
    
    viewModel.output.loading.drive(onNext: { [weak self] _ in
      self?.loadingView.isHidden = false
      self?.contentScrollView.isHidden = true
      self?.retryView.isHidden = true
    })
    .disposed(by: bag)
    
    viewModel.output.loadResult.drive(onNext: { [weak self] result in
      self?.loadingView.isHidden = true
      switch result {
      case .success:
        self?.contentScrollView.isHidden = false
        self?.retryView.isHidden = true
      case .failure:
        self?.contentScrollView.isHidden = true
        self?.retryView.isHidden = false
      }
    })
    .disposed(by: bag)
  }
}

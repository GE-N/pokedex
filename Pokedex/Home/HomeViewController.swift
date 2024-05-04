import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  private var contentWidth: CGFloat?
  
  private lazy var searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Pokemon's name or id"
    return textField
  }()
  
  private lazy var searchBarView: UIView = {
    let view = HomeSearchBar()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentStack.addArrangedSubview(searchTextField)
    return view
  }()
  
  private lazy var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeItem> = {
    let datasource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: collectionView) { collectionView, indexPath, item in
      switch item {
      case let .item(pokemon):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeItemCell.cellIdentifier, for: indexPath) as? HomeItemCell else {
          return UICollectionViewCell()
        }
        cell.setItem(pokemon)
        return cell
      }
    }
    return datasource
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(HomeItemCell.self, forCellWithReuseIdentifier: HomeItemCell.cellIdentifier)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    collectionView.delegate = self
    return collectionView
  }()
  
  private lazy var dismissKeyboardGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(dismissKeyboard))
    gesture.cancelsTouchesInView = false
    return gesture
  }()
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
  
  private let viewModel: HomeViewModel = HomeViewModelImpl()
  private let bag = DisposeBag()
  
  // MARK: -
  
  override func loadView() {
    super.loadView()
    setupLayout()
    bindInput()
    bindOutput()
  }
  
  private func setupLayout() {
    title = "Pokedex"
    
    view.addGestureRecognizer(dismissKeyboardGesture)
    
    view.addSubview(searchBarView)
    NSLayoutConstraint.activate([
      searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  private func bindInput() {
    rx.viewDidLoad.bind(to: viewModel.input.viewDidLoad).disposed(by: bag)
    (searchTextField.rx.text.orEmpty <-> viewModel.input.filterTyped).disposed(by: bag)
    collectionView.rx.itemSelected.bind(to: viewModel.input.itemSelected).disposed(by: bag)
  }
  
  private func bindOutput() {
    viewModel.output.sections
      .drive(onNext: { [weak self] sections in
        guard let self else { return }
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections(sections)
        sections.forEach { section in
          snapshot.appendItems(section.items, toSection: section)
        }
        self.datasource.apply(snapshot, animatingDifferences: true)
      })
      .disposed(by: bag)
    
    viewModel.output.canClearSearchBox.map { canClear -> UITextField.ViewMode in
      canClear ? .always : .never
    }
    .drive(searchTextField.rx.clearButtonMode)
    .disposed(by: bag)
    
    viewModel.output.showInfo
      .drive(onNext: { [weak self] pokemon in
        let viewModel = DetailsViewModelImpl(pokemon: pokemon)
        let detailsView = DetailsViewController(viewModel: viewModel)
        self?.navigationController?.pushViewController(detailsView, animated: true)
      })
      .disposed(by: bag)
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if contentWidth == nil {
      let columnsPerRow = 3
      let spacing = CGFloat(columnsPerRow + 1) * 8.0
      let horizontalInset = collectionView.contentInset.left + collectionView.contentInset.right
      let contextWidth = collectionView.bounds.size.width - horizontalInset - spacing
      self.contentWidth = CGFloat(contextWidth) / CGFloat(columnsPerRow)
    }
    
    return CGSize(width: contentWidth!, height: 150)
  }
}

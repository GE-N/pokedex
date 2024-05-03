import UIKit

class HomeViewController: UIViewController {

  private lazy var searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Type Pokemon's name or id here for search"
    return textField
  }()
  
  private lazy var searchBarView: UIView = {
    let view = HomeSearchBar()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentStack.addArrangedSubview(searchTextField)
    return view
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  override func loadView() {
    super.loadView()
    setupLayout()
  }
  
  func setupLayout() {
    title = "Pokedex"
    
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

}


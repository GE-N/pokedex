import UIKit
import Kingfisher

protocol HomeCellPresentable {
  var id: String { get }
  var name: String { get }
  var imageUrl: URL? { get }
}

final class HomeItemCell: UICollectionViewCell {
  static let cellIdentifier = String(describing: HomeItemCell.self)
  private let style = Style()
  
  private lazy var spriteImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var spriteView: UIView = {
    let view = UIView()
    view.addSubview(spriteImageView)
    NSLayoutConstraint.activate([
      spriteImageView.topAnchor.constraint(equalTo: view.topAnchor),
      spriteImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      spriteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
    return view
  }()
  
  private lazy var idLabel: UILabel = {
    let label = UILabel()
    label.textColor = style.subTextColor
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    return label
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = style.mainTextColor
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.addArrangedSubview(idLabel)
    stackView.addArrangedSubview(spriteView)
    stackView.addArrangedSubview(nameLabel)
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    contentView.layer.cornerRadius = 8
    contentView.layer.borderColor = style.lightGrayColor.cgColor
    contentView.layer.borderWidth = 1
    contentView.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
      contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
    ])
  }
  
  func setItem(_ item: HomeCellPresentable) {
    spriteImageView.kf.setImage(with: item.imageUrl)
    nameLabel.text = item.name
    idLabel.text = " #\(item.id)"
  }
}

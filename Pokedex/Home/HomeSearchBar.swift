import UIKit

final class HomeSearchBar: UIView {
  let contentStack = UIStackView()
  private let style = Style()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.backgroundColor = style.lightGrayColor
    contentView.layer.cornerRadius = 8
    addSubview(contentView)
    
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .horizontal
    contentStack.spacing = 12
    
    let searchIcon = UIImage(named: "home_search_icon")
    let imageView = UIImageView(image: searchIcon)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    contentStack.addArrangedSubview(imageView)
    contentView.addSubview(contentStack)
    NSLayoutConstraint.activate([
      contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
    ])
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}

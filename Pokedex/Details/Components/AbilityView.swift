import UIKit

protocol AbilityViewPresentable {
  var name: String { get }
  var details: String { get }
}

final class AbilityViewBox: UIView {
  private let style = Style()
  
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 24
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
    backgroundColor = style.lightGrayColor
    layer.cornerRadius = 8
    
    addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
  }
  
  func addAbility(_ ability: AbilityView) {
    contentStackView.addArrangedSubview(ability)
  }
}

final class AbilityView: UIView {
  private let style = Style()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    return label
  }()
  
  private lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var contentStackView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = .black.withAlphaComponent(0.25)
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(separator)
    stackView.addArrangedSubview(detailsLabel)
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
    addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
  }
  
  func setAbility(_ ability: AbilityViewPresentable) {
    titleLabel.text = "Ability: \(ability.name)"
    detailsLabel.text = ability.details
  }
}

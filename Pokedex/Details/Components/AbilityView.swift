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
    stackView.spacing = style.padding * 3
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
    layer.cornerRadius = style.cornerRadius
    
    addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: style.padding),
      contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding),
      contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.padding),
      contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.padding),
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
    label.font = style.titleFont
    return label
  }()
  
  private lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.font = style.detailsFont
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
    stackView.spacing = style.padding * 2
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
      contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: style.padding),
      contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding),
      contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.padding),
      contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.padding),
    ])
  }
  
  func setAbility(_ ability: AbilityViewPresentable) {
    titleLabel.text = "Ability: \(ability.name)"
    detailsLabel.text = ability.details
  }
}

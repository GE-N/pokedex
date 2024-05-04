import UIKit

protocol TypeViewPresentable {
  var types: String { get }
  var doubleDamageFrom: String? { get }
  var doubleDamageTo: String? { get }
  var halfDamageFrom: String? { get }
  var halfDamageTo: String? { get }
  var noDamageFrom: String? { get }
  var noDamageTo: String? { get }
}

final class TypeViewBox: UIView {
  private let style = Style()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Types and corelation"
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()
  
  private lazy var typeStackView: UIStackView = {
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
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
    addSubview(typeStackView)
    NSLayoutConstraint.activate([
      typeStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      typeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      typeStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      typeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
  }
  
  func addTypeView(_ view: TypesView) {
    typeStackView.addArrangedSubview(view)
  }
}

final class TypesView: UIView {
  private lazy var typeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    return label
  }()
  
  private lazy var doubleDamageToLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var halfDamageFromLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var noDamageFromLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var doubleDamageFromLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var halfDamageToLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var noDamageToLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.isHidden = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return label
  }()
  
  private lazy var strengthWeakStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.addArrangedSubview(doubleDamageToLabel)
    stackView.addArrangedSubview(halfDamageFromLabel)
    stackView.addArrangedSubview(noDamageFromLabel)
    stackView.addArrangedSubview(doubleDamageFromLabel)
    stackView.addArrangedSubview(halfDamageToLabel)
    stackView.addArrangedSubview(noDamageToLabel)
    return stackView
  }()
  
  private lazy var contentStackView: UIStackView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(typeLabel)
    stackView.addArrangedSubview(separator)
    stackView.addArrangedSubview(strengthWeakStackView)
    
    typeLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
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
    backgroundColor = Style().lightGrayColor
    layer.cornerRadius = 8
    
    addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: topAnchor),
      contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
  
  func setTypes(item: TypeViewPresentable) {
    typeLabel.text = item.types
    
    if let doubleDamageTo = item.doubleDamageTo, !doubleDamageTo.isEmpty {
      doubleDamageToLabel.isHidden = false
      doubleDamageToLabel.text = "😎 2x dmg to: \(doubleDamageTo)"
    }
    
    if let halfDamageFrom = item.halfDamageFrom, !halfDamageFrom.isEmpty {
      halfDamageFromLabel.isHidden = false
      halfDamageFromLabel.text = "😏 0.5x dmg from: \(halfDamageFrom)"
    }
    
    if let noDamageFrom = item.noDamageFrom, !noDamageFrom.isEmpty {
      noDamageFromLabel.isHidden = false
      noDamageFromLabel.text = "😛 0 dmg from: \(noDamageFrom)"
    }
    
    if let doubleDamageFrom = item.doubleDamageFrom, !doubleDamageFrom.isEmpty {
      doubleDamageFromLabel.isHidden = false
      doubleDamageFromLabel.text = "😵 2x dmg from: \(doubleDamageFrom)"
    }
    
    if let halfDamageTo = item.halfDamageTo, !halfDamageTo.isEmpty {
      halfDamageToLabel.isHidden = false
      halfDamageToLabel.text = "😰 0.5x dmg to: \(halfDamageTo)"
    }
    
    if let noDamageTo = item.noDamageTo, !noDamageTo.isEmpty {
      noDamageToLabel.isHidden = false
      noDamageToLabel.text = "😱 0 dmg to: \(noDamageTo)"
    }
  }
}

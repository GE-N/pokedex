import UIKit

class StatViewItem {
  var hp: Int = 0
  var atk: Int = 0
  var def: Int = 0
  var sAtk: Int = 0
  var sDef: Int = 0
  var spd: Int = 0
}

final class StatsView: UIView {
  private lazy var hpLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var attackLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var defenseLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var specialAtkLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var specialDefLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var speedLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var statStackView: UIStackView = {
    let topSpace = UIView()
    topSpace.translatesAutoresizingMaskIntoConstraints = true
    let bottomSpace = UIView()
    bottomSpace.translatesAutoresizingMaskIntoConstraints = true
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    stackView.addArrangedSubview(topSpace)
    stackView.addArrangedSubview(hpLabel)
    stackView.addArrangedSubview(attackLabel)
    stackView.addArrangedSubview(defenseLabel)
    stackView.addArrangedSubview(specialAtkLabel)
    stackView.addArrangedSubview(specialDefLabel)
    stackView.addArrangedSubview(speedLabel)
    stackView.addArrangedSubview(bottomSpace)
    
    // Squeeze info on center.
    topSpace.heightAnchor.constraint(equalTo: bottomSpace.heightAnchor).isActive = true
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
    
    addSubview(statStackView)
    NSLayoutConstraint.activate([
      statStackView.topAnchor.constraint(equalTo: topAnchor),
      statStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      statStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      statStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
  
  func setStats(_ stat: StatViewItem) {
    hpLabel.text = "❤️ HP: \(stat.hp)"
    attackLabel.text = "👊 ATK: \(stat.atk)"
    defenseLabel.text = "🛡️ DEF: \(stat.def)"
    specialAtkLabel.text = "🥊 S.ATK: \(stat.sAtk)"
    specialDefLabel.text = "🛡️ S.DEF: \(stat.sDef)"
    speedLabel.text = "💨 SPD: \(stat.spd)"
  }
}

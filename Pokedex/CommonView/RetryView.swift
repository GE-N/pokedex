import UIKit

final class RetryView: UIView {
  lazy var retryButton = {
    let button = UIButton()
    button.setTitle("Retry", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8
    
    let descriptionLabel = UILabel()
    descriptionLabel.text = "Get data failed 😵"
    descriptionLabel.font = UIFont.systemFont(ofSize: 16)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(retryButton)
    
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
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}

import UIKit

final class DetailsViewController: UIViewController {
  var viewModel: DetailsViewModel!
  
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
  }
  
  func bindInput() {
    
  }
  
  func bindOutput() {
    title = viewModel.output.name
  }
}

import UIKit

class MainMenuViewController: UIViewController {

  var presenter: MainMenuPresenterProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
  }
}

extension MainMenuViewController: MainMenuViewProtocol {
}

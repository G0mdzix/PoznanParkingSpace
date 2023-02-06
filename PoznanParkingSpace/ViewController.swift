import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let t = MainMenuAssembly().build()
    present(t, animated: true)
  }
}

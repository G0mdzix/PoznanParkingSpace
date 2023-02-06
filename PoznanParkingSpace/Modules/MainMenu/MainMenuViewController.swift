import UIKit
import SnapKit

class MainMenuViewController: UIViewController {

  var presenter: MainMenuPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
    layout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  private lazy var button: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .white
    button.tintColor = .black
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    button.layer.cornerRadius = CGFloat(8)
    return button
  }()

  private func layout() {
    addViews()
    buttonLayout()
  }

  private func addViews() {
    view.addSubview(button)
  }

  private func buttonLayout() {
    button.snp.makeConstraints { make in
      make.size.equalTo(100)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }

  @objc private func buttonTapped() {
    print("TAPED")
  }
}

extension MainMenuViewController: MainMenuViewProtocol {
}



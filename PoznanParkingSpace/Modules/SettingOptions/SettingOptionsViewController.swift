import UIKit

class SettingOptionsViewController: UIViewController {

  // MARK: - Properties

  var presenter: SettingOptionsPresenterProtocol?

  // MARK: - Lifecycle

  init(presenter: SettingOptionsPresenterProtocol? = nil) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError(Constants.Coder.fatalError)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

// MARK: - SettingOptionsViewControllerProtocol

extension SettingOptionsViewController: SettingOptionsViewProtocol {
}

// MARK: - PrivateFunctions

extension SettingOptionsViewController {
}

// MARK: - Layouts

extension SettingOptionsViewController {
  private func layout() {
    addViews()
  }

  private func addViews() {
  }
}

// MARK: - Constants

private enum Constants {
  enum Coder {
    static let fatalError = "init(coder:) has not been implemented"
  }
}

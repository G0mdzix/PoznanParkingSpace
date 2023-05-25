import UIKit

class SettingOptionsPresenter {

  // MARK: - Properties

  private let interactor: SettingOptionsInteractorProtocol
  private let router: SettingOptionsRouterProtocol
  weak var view: SettingOptionsViewProtocol?

  // MARK: - Lifecycle

  init(
    view: SettingOptionsViewProtocol,
    interactor: SettingOptionsInteractorProtocol,
    router: SettingOptionsRouterProtocol
  ) {
      self.interactor = interactor
      self.router = router
      self.view = view
  }
}

// MARK: - SettingOptionsPresenterProtocol

extension SettingOptionsPresenter: SettingOptionsPresenterProtocol {
}

// MARK: - PrivateFunctions

extension SettingOptionsPresenter {
}

// MARK: - Constants

private enum Constants {
}

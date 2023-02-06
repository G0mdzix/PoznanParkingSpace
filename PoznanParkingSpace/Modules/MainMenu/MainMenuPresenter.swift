import UIKit

class MainMenuPresenter: MainMenuPresenterProtocol {
  private var interactor: MainMenuInteractorProtocol
  private var router: MainMenuRouterProtocol
  weak var view: MainMenuViewProtocol?

  init(
    view: MainMenuViewProtocol,
    interactor: MainMenuInteractorProtocol,
    router: MainMenuRouterProtocol
  ) {
    self.interactor = interactor
    self.router = router
    self.view = view
  }
}

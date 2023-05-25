import UIKit

class MainMenuAssembly {
  func build() -> UIViewController {
    let view = MainMenuViewController()
    let interactor = MainMenuInteractor()
    let router = MainMenuRouter()
    let presenter = MainMenuPresenter(view: view, interactor: interactor, router: router)
    let netwrokManager: NetworkManagerListner = NetworkManager()

    view.presenter = presenter
    interactor.presenter = presenter
    interactor.networkManager = netwrokManager
    router.view = view

    return view
  }
}

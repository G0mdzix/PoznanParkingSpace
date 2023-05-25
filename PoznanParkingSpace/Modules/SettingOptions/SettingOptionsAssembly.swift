import UIKit

class SettingOptionsAssembly {
  func build() -> UIViewController {
    let view = SettingOptionsViewController()
    let interactor = SettingOptionsInteractor()
    let router = SettingOptionsRouter()
    let presenter = SettingOptionsPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter
    interactor.presenter = presenter
    router.view = view

    return view
  }
}

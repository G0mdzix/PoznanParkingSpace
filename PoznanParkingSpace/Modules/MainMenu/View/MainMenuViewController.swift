import UIKit
import SnapKit
import SwiftSpinner

class MainMenuViewController: UIViewController {

  // MARK: - Properties

  var presenter: MainMenuPresenterProtocol?

  // MARK: - Properties (Private Subviews)

  private let mapButton = UIFactory.makeMapButton(
    target: self,
    action: #selector(buttonTapped)
  )
  private let searchBar = UIFactory.makeStreetSearchBar()
  private let backgroundSearchBar = UIFactory.makeUIView()

  // MARK: - Do naprawy

  let tableView = UIFactory.makeTableView()
  var isSearch = false
  var zapamietanaTablica: [ParkingSpace] = []

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    sprawdzam()
  }

  private func sprawdzam() {
    configure()
    layout()

    configureNavigationBar(preferredLargeTitle: true)
    presenter?.onFetchPoznanParkingSpaceList()
    view.backgroundColor = AppColorMode.currentMode().mainColor
    configureItems()
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
}

// MARK: - MainMenuViewProtocol

extension MainMenuViewController: MainMenuViewProtocol {
  func showLoading() {
    SwiftSpinner.useContainerView(view)
    SwiftSpinner.show("FETCHING")
  }

  func hideLoading() {
    SwiftSpinner.hide()
    Task { tableView.reloadData() }
  }
}

// MARK: - Configure

extension MainMenuViewController {
  private func configure() {
    configureTableView()
    configureSearchBar()
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.backgroundColor = Colors.transparent
    tableView.dataSource = self
  }

  private func configureSearchBar() {
    searchBar.delegate = self
    navigationItem.titleView = searchBar
  }
}

// MARK: - PrivateFunctions

extension MainMenuViewController {
  @objc
  private func buttonTapped() {
    presenter?.onParkingMapSelected(poznanParkingList: zapamietanaTablica)
  }
}

// MARK: - Layouts

extension MainMenuViewController {
  private func layout() {
    addViews()
    tableViewLayout()
    mapButtonLayout()
    searchBarLayout()
    backgroundSearchBarLayout()
  }

  private func addViews() {
    view.addSubview(tableView)
    view.addSubview(mapButton)
    view.addSubview(backgroundSearchBar)
    view.addSubview(searchBar)
  }

  private func backgroundSearchBarLayout() {
    backgroundSearchBar.snp.makeConstraints { make in
      make.center.equalTo(searchBar)
      make.width.equalTo(tableView)
      make.height.equalTo(searchBar).offset(-Constans.Layout.defaultOffset)
    }
  }

  private func searchBarLayout() {
    searchBar.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mapButton.snp.bottom).offset(Constans.Layout.defaultOffset)
      make.trailing.equalToSuperview().offset(-Constans.Layout.defaultOffset)
      make.leading.equalToSuperview().offset(Constans.Layout.defaultOffset)
      make.height.equalTo(100)
    }
  }

  private func tableViewLayout() {
    tableView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
      make.trailing.bottom.equalToSuperview().offset(-Constans.Layout.defaultOffset)
      make.leading.equalToSuperview().offset(Constans.Layout.defaultOffset)
    }
  }

  private func mapButtonLayout() {
    mapButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-Constans.Layout.defaultOffset)
      make.leading.equalToSuperview().offset(Constans.Layout.defaultOffset)
      make.height.equalTo(Constans.Button.height)
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constans.Layout.defaultOffset)
    }
  }
}

// MARK: - Constants

private enum Constans {
  enum Layout {
    static let defaultOffset: CGFloat = 20
  }

  enum Button {
    static let height: CGFloat = 60
  }
}

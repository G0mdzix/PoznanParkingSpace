import Foundation
import UIKit

extension MainMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let presenter = presenter else { return 0 }
    switch isSearch {
    case true:
      return presenter.poznanParkingFilteredListCount()
    case false:
      return presenter.poznanParkingListCount()
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "Constants.TableView.identifier"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

    guard let presenter = presenter else { return UITableViewCell() }
    switch isSearch {
    case true:
      cell.backgroundColor = AppColorMode.currentMode().secondaryColor
      cell.textLabel?.text =
      presenter.poznanParkingFilteredListItems(at: indexPath.row)?.properties.street
      cell.textLabel?.textColor = AppColorMode.currentMode().mainColor
      cell.textLabel?.font = Fonts.tableViewBold
      cell.textLabel?.textAlignment = .center
    case false:
      cell.backgroundColor = AppColorMode.currentMode().secondaryColor
      cell.textLabel?.text = presenter.poznanParkingListItems(at: indexPath.row)?.properties.street
      cell.textLabel?.textColor = AppColorMode.currentMode().mainColor
      cell.textLabel?.font = Fonts.tableViewBold
      cell.textLabel?.textAlignment = .center
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presenter = presenter else { return }
    guard let test1 = presenter.poznanParkingFilteredListItems(at: indexPath.row) else { return }
    guard let test2 = presenter.poznanParkingListItems(at: indexPath.row) else { return }
    switch isSearch {
    case true:
      zapamietanaTablica = [test1] // !
    case false:
      zapamietanaTablica = [test2] // !
    }
  }
}

extension MainMenuViewController: UISearchBarDelegate {

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearch = true
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    isSearch = false
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    isSearch = false
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    isSearch = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
    guard let presenter = presenter else { return }
    switch textSearched.isEmpty {
    case true:
      isSearch = false
      self.tableView.reloadData()
    case false:
      presenter.filterToSearch(searchText: textSearched)
    }
    guard let filteredPoznanParkingSpaceList = presenter.filteredPoznanParkingSpaceList else {
      return
    }
    switch filteredPoznanParkingSpaceList.isEmpty {
    case true:
      isSearch = false
    case false:
      isSearch = true
    }
    self.tableView.reloadData()
  }
}

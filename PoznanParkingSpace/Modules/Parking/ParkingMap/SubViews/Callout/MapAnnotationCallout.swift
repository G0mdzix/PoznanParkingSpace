import Foundation
import UIKit
import MapKit

class MapAnnotationCallout: UIView {

  // MARK: - Properties

  private let annotation: MapAnnotation

  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.isHidden = false
    return table
  }()

  // MARK: - Lifecycle

  init(annotation: MapAnnotation) {
    self.annotation = annotation
    super.init(frame: .zero)
    layout()
    configureTableView()
  }

  required init?(coder: NSCoder) {
    fatalError(Constants.Coder.fatalError)
  }

  // MARK: - Layouts

  private func layout() {
    addViews()
    tableViewLayout()
  }

  private func addViews() {
    addSubview(tableView)
  }

  func tableViewLayout() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - PrivateFunctions

  private func configureTableView() {
    tableView.backgroundColor = Colors.transparent
    tableView.dataSource = self
  }
}

// MARK: - ParkingSpaceAnnotationCalloutTableViewDataSource

extension MapAnnotationCallout: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(
      MapAnnotationTableViewCell.self,
      forCellReuseIdentifier: Constants.TableView.identifier
    )
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: Constants.TableView.identifier,
      for: indexPath
    )
    as? MapAnnotationTableViewCell else {
      return UITableViewCell()
    }
    provideDataToEachRow(indexPathRow: indexPath.row, cell: cell)
    cell.backgroundColor = Colors.transparent
    return cell
  }

  func provideDataToEachRow(indexPathRow: Int, cell: MapAnnotationTableViewCell) {
    switch indexPathRow {
    case 0:
      cell.titleLabel.text = Constants.TableView.streetLabel
      cell.descriptionLabel.text = annotation.street
    case 1:
      cell.titleLabel.text = Constants.TableView.zoneLabel
      cell.descriptionLabel.text = annotation.zone
    case 2:
      cell.titleLabel.text = Constants.TableView.cardLabel
      cell.descriptionLabel.text = annotation.card
    case 3:
      cell.titleLabel.text = Constants.TableView.pekaLabel
      cell.descriptionLabel.text = annotation.peka
    case 4:
      cell.titleLabel.text = Constants.TableView.blikLabel
      cell.descriptionLabel.text = annotation.blik
    case 5:
      cell.titleLabel.text = Constants.TableView.bilonLabel
      cell.descriptionLabel.text = annotation.bilon
    default:
      break
    }
  }
}

// MARK: - Constants

private enum Constants {
  enum Coder {
    static let fatalError = "init(coder:) has not been implemented"
  }

  enum TableView {
    static let identifier = "CalloutTableView"
    
    static let streetLabel = "Ulica: "
    static let zoneLabel = "Strefa: "
    static let cardLabel = "Płatność karta: "
    static let pekaLabel = "Płatność PEKĄ: "
    static let blikLabel = "Płatność BLIKIEM: "
    static let bilonLabel = "Płatność Gotówką: "
  }
}

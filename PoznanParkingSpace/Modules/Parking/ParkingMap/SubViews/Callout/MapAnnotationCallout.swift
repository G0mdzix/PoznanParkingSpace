import Foundation
import UIKit
import MapKit

class MapAnnotationCallout: UIView {

  // MARK: - Properties

  private let annotation: MapAnnotation
  private let tableView = UIFactory.makeTableView()

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
    return 7
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
      cell.titleLabel.font = Fonts.defaultBold
    case 1:
      cell.titleLabel.text = Constants.TableView.zoneLabel
      cell.descriptionLabel.text = annotation.zone
      cell.titleLabel.font = Fonts.defaultBold
    case 2:
      cell.titleLabel.text = Constants.TableView.cardLabel
      cell.descriptionLabel.text = annotation.card
      cell.titleLabel.font = Fonts.defaultBold
    case 3:
      cell.titleLabel.text = Constants.TableView.pekaLabel
      cell.descriptionLabel.text = annotation.peka
      cell.titleLabel.font = Fonts.defaultBold
    case 4:
      cell.titleLabel.text = Constants.TableView.blikLabel
      cell.descriptionLabel.text = annotation.blik
      cell.titleLabel.font = Fonts.defaultBold
    case 5:
      cell.titleLabel.text = Constants.TableView.bilonLabel
      cell.descriptionLabel.text = annotation.bilon
      cell.titleLabel.font = Fonts.defaultBold
    case 6:
      cell.titleLabel.text = Constants.TableView.freeSpaceLabel
      cell.descriptionLabel.text = String(annotation.freeSpots)
      cell.titleLabel.font = Fonts.defaultBold
      cell.descriptionLabel.textColor = .blue
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
    static let freeSpaceLabel = "Liczba wolnych miejsc"
  }
}

import Foundation
import UIKit
import SnapKit

class MapAnnotationTableViewCell: UITableViewCell {

  // MARK: - Properties (UIViews)

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: Constants.Label.fontSize)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: Constants.Label.fontSize)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
    checkLabelsStringsToSetColors()
  }

  required init?(coder: NSCoder) {
    fatalError(Constants.Coder.fatalError)
  }

  // MARK: - Layouts

  private func layout() {
    addViews()
    layoutTitleLabel()
    layoutDescriptionLabel()
  }

  private func addViews() {
    addSubview(titleLabel)
    addSubview(descriptionLabel)
  }

  private func layoutTitleLabel() {
    titleLabel.snp.makeConstraints { make in
      make.leftMargin.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }

  private func layoutDescriptionLabel() {
    descriptionLabel.snp.makeConstraints { make in
      make.rightMargin.equalToSuperview().offset(-Constants.Label.offset)
      make.centerY.equalToSuperview()
    }
  }

  // MARK: - PrivateFunctions

  func checkLabelsStringsToSetColors() {
    Task {
      switch descriptionLabel.text {
      case Constants.Label.CheckString.yes:
        descriptionLabel.textColor = .green
      case Constants.Label.CheckString.no:
        descriptionLabel.textColor = .red
      default:
        descriptionLabel.textColor = .black
      }
    }
  }
}

// MARK: - Constants

private enum Constants {
  enum Coder {
    static let fatalError = "init(coder:) has not been implemented"
  }

  enum Label {
    static let offset = CGFloat(10)
    static let fontSize = CGFloat(20)

    enum CheckString {
      static let yes = "TAK"
      static let no = "NIE"
    }
  }
}

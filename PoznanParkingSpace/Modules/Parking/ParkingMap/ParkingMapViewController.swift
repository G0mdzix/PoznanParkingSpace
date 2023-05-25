import UIKit
import MapKit
import Photos
import SnapKit

class ParkingMapViewController: UIViewController {

  // MARK: - Properties

  var presenter: ParkingMapPresenterProtocol?

  // MARK: - Properties (Private)

  private let mapView = UIFactory.makeMapView()

  // MARK: - Lifecycle

  init(presenter: ParkingMapPresenterProtocol? = nil) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError(Constants.Coder.fatalError)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let presenter = presenter else { return }
    layout()
    configure()
    presenter.onViewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

// MARK: - ParkingMapViewControllerProtocol

extension ParkingMapViewController: ParkingMapViewProtocol {
  func displayAnnotations(parkingAnnotationList: [MapAnnotation]) {
    Task {
      mapView.addAnnotations(parkingAnnotationList)
    }
  }
}

// MARK: - PrivateFunctions 

extension ParkingMapViewController {
  // M.G - function's provided to test
  func centerToPoznan() {
    let cityRegion = MKCoordinateRegion(
      center: Constants.DataToTest.poznanCoordinates,
      latitudinalMeters: Constants.DataToTest.distance,
      longitudinalMeters: Constants.DataToTest.distance
    )
    mapView.setRegion(cityRegion, animated: true)
  }
}

extension ParkingMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let annotation = view.annotation as? MapAnnotation {
      view.canShowCallout = true
      Task { 
        view.detailCalloutAccessoryView = self.makeAnnotationCallout(annotation: annotation)
        view.image = UIImage(named: "fire")
      }
    }
  }
}

extension ParkingMapViewController {
  private func configure() {
    configureMapView()
    centerToPoznan()
  }

  private func configureMapView() {
    mapView.delegate = self
  }
}

// MARK: - Layouts

extension ParkingMapViewController {
  private func layout() {
    addViews()
    mapViewLayout()
  }

  private func addViews() {
    view.addSubview(mapView)
  }

  private func mapViewLayout() {
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func makeAnnotationCallout(annotation: MapAnnotation) -> MapAnnotationCallout {
    let annotation = MapAnnotationCallout(annotation: annotation)
    annotation.snp.makeConstraints { make in
      make.height.equalTo(Constants.Annotation.height)
      make.width.equalTo(Constants.Annotation.width)
    }
    return annotation
  }
}

// MARK: - Constants

private enum Constants {
  enum Coder {
    static let fatalError = "init(coder:) has not been implemented"
  }

  enum Annotation {
    static let width = CGFloat(400)
    static let height = CGFloat(300)
  }

  //Dummy data provided to do some tests
  enum DataToTest {
    static let poznanCoordinates = CLLocationCoordinate2D(
      latitude: 52.409538,
      longitude: 16.931992
    )
    static let distance = CLLocationDistance(4000)
  }
}

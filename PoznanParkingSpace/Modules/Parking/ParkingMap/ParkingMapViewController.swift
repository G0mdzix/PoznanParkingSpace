import UIKit
import MapKit
import SnapKit
import SwiftSpinner
import Combine

class ParkingMapViewController: UIViewController {

  // MARK: - Properties

  var presenter: ParkingMapPresenterProtocol?

  // MARK: - Properties (Private)

  private var cancellables = Set<AnyCancellable>()

  private let mapView = UIFactory.makeMapView()
  private let backButton = UIFactory.makeBackButton(
    target: self,
    action: #selector(goBack)
  )
  private let detectionButton = UIFactory.makeDetectionButton(
    target: self,
    action: #selector(goToCam)
  )

  private let savedDistanceLabel = UIFactory.makeLabel()
  private let savedCo2Label = UIFactory.makeLabel()
  private let savedFuelLabel = UIFactory.makeLabel()
  private let labelBackground = UIFactory.makeUIView()

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
    navigationController?.setNavigationBarHidden(true, animated: true)
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
  func showLabels(savedCo2: String, savedFuel: String, savedDistance: String) {
    Task {
      savedCo2Label.text = "Zmniejszono emisje \(savedCo2) CO2/g"
      savedFuelLabel.text = "Zaoszczedono \(savedFuel) L"
      savedDistanceLabel.text = "Skrocono jazdę o \(savedDistance) Km"
      labelBackgroundLayout()
    }
  }

  func displayAnnotations(parkingAnnotationList: [MapAnnotation]) {
    Task {
      mapView.addAnnotations(parkingAnnotationList)
      if parkingAnnotationList.count == 1 {
        displayAutoRoutingToAnnotation(parkingAnnotation: parkingAnnotationList[0].coordinate)
      }
    }
  }
}

// MARK: - PrivateFunctions 

extension ParkingMapViewController {
  private func hideLabels() {
    savedCo2Label.isHidden = true
    savedFuelLabel.isHidden = true
    savedDistanceLabel.isHidden = true
  }

  private func showLabels() {
    savedCo2Label.isHidden = false
    savedFuelLabel.isHidden = false
    savedDistanceLabel.isHidden = false
  }

  private func displayAutoRoutingToAnnotation(parkingAnnotation: CLLocationCoordinate2D) {
    let userLocationService = UserLocationService.shared

    let locationSubscription = userLocationService.currentLocationPublisher
        .sink { location in
            if let location = location {
              AutoRouting().calculateAutoRouting(
                userCurrentLocation: location,
                stationLocation: CLLocation(
                  latitude: parkingAnnotation.latitude,
                  longitude: parkingAnnotation.longitude
                ),
                mapKit: self.mapView
              )
            }
        }
        .store(in: &cancellables)
  }

  func removeAnnotationsExceptSelected(mapView: MKMapView, selectedAnnotation: MKAnnotation) {
    for annotation in mapView.annotations {
      if annotation !== selectedAnnotation {
        mapView.removeAnnotation(annotation)
        //displayAutoRoutingToAnnotation(parkingAnnotation: selectedAnnotation.coordinate)
      }
    }
  }

  func removeAllAnnotations() {
    Task {
      mapView.removeOverlays(mapView.overlays)
      mapView.removeAnnotation(mapView.annotations.first!)
    }
  }
  
  @objc
  func goBack() {
    navigationController?.popViewController(animated: true) // to router
  }

  @objc
  func goToCam() {
    let vc = ViewController()
    navigationController?.pushViewController(vc, animated: true)
  }

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
      }
      if let selectedAnnotation = view.annotation {
        removeAnnotationsExceptSelected(mapView: mapView, selectedAnnotation: selectedAnnotation)
      }
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .red
    renderer.lineWidth = 5.0
    return renderer
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
    backButtonLayout()
    camButtonLayout()
    savedFuelLabelLayout()
    savedCo2LabelLayout()
    savedDistanceLabelLayout()
  }

  private func addViews() {
    view.addSubview(mapView)
    view.addSubview(backButton)
    view.addSubview(detectionButton)
    view.addSubview(labelBackground)
    view.addSubview(savedCo2Label)
    view.addSubview(savedFuelLabel)
    view.addSubview(savedDistanceLabel)
  }

  private func labelBackgroundLayout() {
    labelBackground.snp.makeConstraints { make in
      make.centerX.equalTo(savedCo2Label)
      make.width.equalTo(savedCo2Label).offset(15)
      make.top.equalTo(savedDistanceLabel).offset(-10)
      make.bottom.equalTo(savedCo2Label).offset(10)
    }
  }

  private func savedCo2LabelLayout() {
    savedCo2Label.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-30)
      make.left.equalToSuperview().offset(20)
    }
  }

  private func savedFuelLabelLayout() {
    savedFuelLabel.snp.makeConstraints { make in
      make.bottom.equalTo(savedCo2Label).offset(-30)
      make.left.equalToSuperview().offset(20)
    }
  }

  private func savedDistanceLabelLayout() {
    savedDistanceLabel.snp.makeConstraints { make in
      make.bottom.equalTo(savedFuelLabel).offset(-30)
      make.left.equalToSuperview().offset(20)
    }
  }

  private func camButtonLayout() {
    detectionButton.snp.makeConstraints { make in
      make.size.equalTo(46)
      make.bottomMargin.equalToSuperview().offset(-20)
      make.right.equalToSuperview().offset(-20)
    }
  }

  private func backButtonLayout() {
    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.snp_topMargin).inset(view.safeAreaInsets)
      make.left.equalToSuperview().offset(Constants.BackButton.leftOffset)
      make.size.equalTo(Constants.BackButton.size)
    }
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

  enum BackButton {
    static let size: CGFloat = 40
    static let leftOffset: CGFloat = 20
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

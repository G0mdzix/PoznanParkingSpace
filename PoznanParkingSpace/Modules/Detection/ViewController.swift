// swiftlint:disable all

import UIKit
import Vision
import CoreMedia
import SwiftSpinner

class ViewController: UIViewController {

    // MARK: - UI Properties
    private let videoPreview: UIView = UIView()
    private let boxesView: DrawingBoundingBoxView = DrawingBoundingBoxView()
    private let labelsTableView: UITableView = UITableView()

    private let inferenceLabel: UILabel = UILabel()
    private let etimeLabel: UILabel = UILabel()
    private let fpsLabel: UILabel = UILabel()

    private let goBackButton = UIFactory.makeBackButton(
      target: self,
      action: #selector(goBack)
    )
  
    // MARK - Core ML model
    private lazy var objectDectectionModel: PoznanParkingSpaceMLModel_ObjectDetectionML? = {
        do {
            return try PoznanParkingSpaceMLModel_ObjectDetectionML()
        } catch {
            fatalError("Failed to load the model: \(error)")
        }
    }()

    // MARK: - Vision Properties
    private var request: VNCoreMLRequest?
    private var visionModel: VNCoreMLModel?
    private var isInferencing = false

    // MARK: - AV Property
    private var videoCapture: VideoCapture!
    private let semaphore = DispatchSemaphore(value: 1)
    private var lastExecution = Date()

    // MARK: - TableView Data
    private var predictions: [VNRecognizedObjectObservation] = []

    // MARK - Performance Measurement Property
    private let 👨‍🔧 = 📏()

    private let maf1 = MovingAverageFilter()
    private let maf2 = MovingAverageFilter()
    private let maf3 = MovingAverageFilter()

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the model
        setUpModel()

        // setup camera
        setUpCamera()

        // setup delegate for performance measurement
        👨‍🔧.delegate = self

        // add subviews and configure constraints
        setupSubviews()
        configureConstraints()

      navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }

    // MARK: - Setup Core ML
    private func setUpModel() {
        guard let objectDectectionModel = objectDectectionModel else { fatalError("Failed to load the model") }
        do {
            let visionModel = try VNCoreMLModel(for: objectDectectionModel.model)
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } catch {
            fatalError("Failed to create vision model: \(error)")
        }
    }

    // MARK: - SetUp Video
    private func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .hd1920x1080) { success in

            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }

                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }

  @objc
  func goBack() {
    navigationController?.popViewController(animated: true)
  }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }

    private func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = view.bounds
        videoCapture.previewLayer?.videoGravity = .resizeAspectFill
    }

    private func setupSubviews() {
        // Configure videoPreview
        view.addSubview(videoPreview)

        // Configure boxesView
        view.addSubview(boxesView)

      view.addSubview(goBackButton)
    }

  private func configureConstraints() {
      // Configure videoPreview constraints
      videoPreview.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }

      // Configure boxesView constraints
      boxesView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }

    goBackButton.snp.makeConstraints { make in
      make.top.equalTo(view.snp_topMargin).inset(view.safeAreaInsets)
      make.left.equalToSuperview().offset(20)
      make.size.equalTo(40)
    }
  }

  func showAlert() {
    let alert = UIAlertController(
      title: "Poprawnie wykryto pojazd!",
      message: "🥳 🚗 🥳",
      preferredStyle: .alert
    )

    let okAction = UIAlertAction(
      title: "Ok",
      style: .default
    ) { _ in
      self.dismiss(animated: true)
    }

    alert.addAction(okAction)
    present(alert, animated: true)
  }
}

// MARK: - VideoCaptureDelegate
extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true

            // start of measure
            self.👨‍🔧.🎬👏()

            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension ViewController {
    private func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    // MARK: - Post-processing
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.👨‍🔧.🏷(with: "endInference")
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            self.predictions = predictions
            DispatchQueue.main.async {
                self.boxesView.predictedObjects = predictions
              if predictions.last?.label == "Car" {
                if predictions.last?.confidence ?? 0 > 0.5 {
                  self.showAlert()
                }
              }
                self.labelsTableView.reloadData()

                // end of measure
                self.👨‍🔧.🎬🤚()

                self.isInferencing = false
            }
        } else {
            // end of measure
            self.👨‍🔧.🎬🤚()

            self.isInferencing = false
        }
        self.semaphore.signal()
    }
}

// MARK: - 📏(Performance Measurement) Delegate
extension ViewController: 📏Delegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        DispatchQueue.main.async {
            self.maf1.append(element: Int(inferenceTime*1000.0))
            self.maf2.append(element: Int(executionTime*1000.0))
            self.maf3.append(element: fps)

            self.inferenceLabel.text = "inference: \(self.maf1.averageValue) ms"
            self.etimeLabel.text = "execution: \(self.maf2.averageValue) ms"
            self.fpsLabel.text = "fps: \(self.maf3.averageValue)"
        }
    }
}

class MovingAverageFilter {
    private var arr: [Int] = []
    private let maxCount = 10

    public func append(element: Int) {
        arr.append(element)
        if arr.count > maxCount {
            arr.removeFirst()
        }
    }

    public var averageValue: Int {
        guard !arr.isEmpty else { return 0 }
        let sum = arr.reduce(0) { $0 + $1 }
        return Int(Double(sum) / Double(arr.count))
    }
}

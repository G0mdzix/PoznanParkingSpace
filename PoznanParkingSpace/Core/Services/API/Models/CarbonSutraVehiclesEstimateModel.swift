// swiftlint:disable all

import Foundation

struct VehicleEstimateResponse: Codable {
    struct Data: Codable {
        let type: String?
        let distance_unit: String?
        let distance_value: String?
        let vehicle_make: String?
        let vehicle_model: String?
        let co2e_gm: Int?
        let co2e_kg: Double?
        let co2e_mt: Double?
        let co2e_lb: Double?
    }

    let data: Data?
    let success: Bool?
    let status: Int?
}


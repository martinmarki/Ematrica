//
//  HighwayInfo.swift
//  Ematrica

struct HighwayInfoResponse: Codable {
    let requestId: String
    let statusCode: String
    let payload: HighwayInfoPayload
}

struct HighwayInfoPayload: Codable {
    let highwayVignettes: [HighwayVignette]
    let vehicleCategories: [VehicleCategory]
    let counties: [County]
}

struct HighwayVignette: Codable {
    let vignetteType: [String]
    let vehicleCategory: String
    let cost: Double
    let trxFee: Double
    let sum: Double
}

struct VehicleCategory: Codable {
    let category: String
    let vignetteCategory: String
    let name: CountryNames
}

struct County: Codable {
    let id: String
    let name: String
}

extension HighwayVignette {
    static let mocks: [HighwayVignette] = [
        HighwayVignette(vignetteType: ["WEEK"],  vehicleCategory: "CAR", cost: 6200,  trxFee: 200, sum: 6400),
        HighwayVignette(vignetteType: ["MONTH"], vehicleCategory: "CAR", cost: 10160, trxFee: 200, sum: 10360),
        HighwayVignette(vignetteType: ["DAY"],   vehicleCategory: "CAR", cost: 4950,  trxFee: 200, sum: 5150)
    ]
}

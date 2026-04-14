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

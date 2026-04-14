//
//  VehicleInfo.swift
//  Ematrica

struct VehicleInfoResponse: Codable {
    let statusCode: String
    let internationalRegistrationCode: String
    let type: String
    let name: String
    let plate: String
    let country: CountryNames
    let vignetteType: String
}

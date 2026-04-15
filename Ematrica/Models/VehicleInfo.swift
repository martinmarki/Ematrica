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

extension VehicleInfoResponse {
    static let mock = VehicleInfoResponse(
        statusCode: "OK",
        internationalRegistrationCode: "H",
        type: "CAR",
        name: "Michael Scott",
        plate: "ABC 123",
        country: CountryNames(hu: "Magyarország", en: "Hungary"),
        vignetteType: "D1"
    )
}

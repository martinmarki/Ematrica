//
//  HighwayInfo.swift
//  Ematrica

struct HighwayInfoResponse: Codable {
    let requestId: Int
    let statusCode: String
    let payload: HighwayInfoPayload
}

struct HighwayInfoPayload: Codable {
    let highwayVignettes: [HighwayVignette]
    let vehicleCategories: [VehicleCategory]
    let counties: [County]
}

struct HighwayVignette: Codable, Hashable {
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

struct County: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}

extension County {
    static let mocks: [County] = [
        County(id: "YEAR_11", name: "Bács-Kiskun"),
        County(id: "YEAR_12", name: "Baranya"),
        County(id: "YEAR_14", name: "Borsod-Abaúj-Zemplén"),
        County(id: "YEAR_15", name: "Csongrád"),
        County(id: "YEAR_16", name: "Fejér"),
        County(id: "YEAR_17", name: "Győr-Moson-Sopron")
    ]
}

extension HighwayVignette {
    static let mocks: [HighwayVignette] = [
        HighwayVignette(vignetteType: ["WEEK"],  vehicleCategory: "CAR", cost: 6200,  trxFee: 200, sum: 6400),
        HighwayVignette(vignetteType: ["MONTH"], vehicleCategory: "CAR", cost: 10160, trxFee: 200, sum: 10360),
        HighwayVignette(vignetteType: ["DAY"],   vehicleCategory: "CAR", cost: 4950,  trxFee: 200, sum: 5150)
    ]
}

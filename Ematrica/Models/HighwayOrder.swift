//
//  HighwayOrder.swift
//  Ematrica

struct HighwayOrderRequest: Codable {
    let highwayOrders: [HighwayOrder]
}

struct HighwayOrder: Codable {
    let type: String
    let category: String
    let cost: Double
}

struct HighwayOrderResponse: Codable {
    let statusCode: String
    let receivedOrders: [HighwayOrder]
}

struct HighwayOrderErrorResponse: Codable {
    let statusCode: String
    let message: String
}

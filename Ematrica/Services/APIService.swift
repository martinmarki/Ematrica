//
//  APIService.swift
//  Ematrica

import Foundation

protocol APIServiceProtocol {
    func getHighwayInfo() async throws -> HighwayInfoResponse
    func getVehicleInfo() async throws -> VehicleInfoResponse
    func postHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse
}

final class APIService: APIServiceProtocol {
    private let session: URLSession = .shared
    private let baseURLString: String = "http://0.0.0.0:8080"
    private let decoder = JSONDecoder()

    func getHighwayInfo() async throws -> HighwayInfoResponse {
        guard let url = URL(string: "\(baseURLString)/v1/highway/info") else { throw APIError.invalidURL }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard http.statusCode == 200 else { throw APIError.httpError(statusCode: http.statusCode) }
        
        return try decoder.decode(HighwayInfoResponse.self, from: data)
    }

    func getVehicleInfo() async throws -> VehicleInfoResponse {
        guard let url = URL(string: "\(baseURLString)/v1/highway/vehicle") else { throw APIError.invalidURL }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard http.statusCode == 200 else { throw APIError.httpError(statusCode: http.statusCode) }
        
        return try decoder.decode(VehicleInfoResponse.self, from: data)
    }

    func postHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse {
        guard let url = URL(string: "\(baseURLString)/v1/highway/order") else {
            throw APIError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        if http.statusCode == 400 {
            let errorBody = try decoder.decode(HighwayOrderErrorResponse.self, from: data)
            throw APIError.orderFailed(message: errorBody.message)
        }
        guard http.statusCode == 200 else { throw APIError.httpError(statusCode: http.statusCode) }

        return try decoder.decode(HighwayOrderResponse.self, from: data)
    }
}

//
//  APIServiceProtocol.swift
//  Ematrica

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case orderFailed(message: String)
    case decodingFailed(Error)
}

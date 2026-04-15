//
//  VignetteSelectionViewModel.swift
//  Ematrica

import Foundation

@Observable
@MainActor
final class VignetteSelectionViewModel {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    var vehicle: VehicleInfoResponse?
    var nationalVignettes: [HighwayVignette] = []
    var isLoading = false
    var selectedVignette: [String]?
    var navigateToConfirmation = false
    private var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let vehicleResult = apiService.getVehicleInfo()
            async let infoResult = apiService.getHighwayInfo()
            vehicle = try await vehicleResult
            nationalVignettes = try await infoResult.payload.highwayVignettes.filter {
                $0.vignetteType.contains(where: { ["DAY", "WEEK", "MONTH"].contains($0) })
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

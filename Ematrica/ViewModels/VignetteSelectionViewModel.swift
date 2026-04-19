//
//  VignetteSelectionViewModel.swift
//  Ematrica

import Foundation
import Factory

@Observable
@MainActor
final class VignetteSelectionViewModel {
    @ObservationIgnored @Injected(\.apiService) private var apiService
    
    var isLoading = false
    var selectedVignette: [String]?
    var errorMessage: String?
    var nationalVignettes: [HighwayVignette] = []
    var vehicle: VehicleInfoResponse?
    var selectedVignetteOption: HighwayVignette? {
        guard let selected = selectedVignette else { return nil }
        return nationalVignettes.first { $0.vignetteType == selected }
    }

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

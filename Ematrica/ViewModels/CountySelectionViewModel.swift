//
//  CountySelectionViewModel.swift
//  Ematrica

import Foundation

@Observable
@MainActor
final class CountySelectionViewModel {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    var counties: [County] = []
    var vehicle: VehicleInfoResponse?
    var countyVignette: HighwayVignette?
    var selectedIDs: Set<String> = []
    var isLoading = false
    var errorMessage: String?
    var navigateToConfirmation = false
    var showNoSelectionAlert = false

    var selectedCounties: [County] {
        counties.filter { selectedIDs.contains($0.id) }
    }

    var totalAmount: Int {
        selectedIDs.count * Int(countyVignette?.sum ?? 0)
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let vehicleResult = apiService.getVehicleInfo()
            async let infoResult = apiService.getHighwayInfo()
            vehicle = try await vehicleResult
            let info = try await infoResult
            counties = info.payload.counties
            countyVignette = info.payload.highwayVignettes.first { $0.vignetteType.contains { $0.hasPrefix("YEAR_") } }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func onNextTapped() {
        if selectedIDs.isEmpty {
            showNoSelectionAlert = true
        } else {
            navigateToConfirmation = true
        }
    }
}

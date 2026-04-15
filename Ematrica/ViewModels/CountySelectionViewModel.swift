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
    var selectedIDs: Set<String> = []
    var isLoading = false
    var errorMessage: String?
    var navigateToConfirmation = false
    var showNoSelectionAlert = false

    let countyVignettePrice = 5450

    var selectedCounties: [County] {
        counties.filter { selectedIDs.contains($0.id) }
    }

    var totalAmount: Int {
        selectedIDs.count * countyVignettePrice
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let vehicleResult = apiService.getVehicleInfo()
            async let infoResult = apiService.getHighwayInfo()
            vehicle = try await vehicleResult
            counties = try await infoResult.payload.counties
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

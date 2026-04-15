//
//  PurchaseConfirmationViewModel.swift
//  Ematrica

import Foundation
import Observation

@Observable
@MainActor
final class PurchaseConfirmationViewModel {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    var isLoading = false
    var showSuccessAlert = false
    var showErrorAlert = false
    var errorMessage: String?

    func confirmPurchase(vehicle: VehicleInfoResponse, vignette: HighwayVignette) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let order = HighwayOrder(
                type: vignette.vignetteType.first ?? "",
                category: vehicle.type,
                cost: vignette.cost
            )
            let response = try await apiService.postHighwayOrder(HighwayOrderRequest(highwayOrders: [order]))
            if response.statusCode == "OK" {
                showSuccessAlert = true
            } else {
                errorMessage = "A tranzakció nem sikerült. Kérjük próbálja újra."
                showErrorAlert = true
            }
        } catch APIError.orderFailed(let message) {
            errorMessage = message
            showErrorAlert = true
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

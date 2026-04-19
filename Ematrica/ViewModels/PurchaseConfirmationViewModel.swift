//
//  PurchaseConfirmationViewModel.swift
//  Ematrica

import Factory
import Observation
import Foundation

@Observable
@MainActor
final class PurchaseConfirmationViewModel {
    @ObservationIgnored @Injected(\.apiService) private var apiService
    let vehicle: VehicleInfoResponse
    let orders: [HighwayOrder]
    let typeName: String
    let displayItems: [(name: String, cost: Int)]
    let total: Int

    init(vehicle: VehicleInfoResponse, vignette: HighwayVignette) {
        self.vehicle = vehicle
        self.orders = [HighwayOrder(type: vignette.vignetteType.first ?? "", category: vehicle.type, cost: vignette.cost)]
        self.typeName = vignette.vignetteType.map(\.vignetteDisplayName).joined(separator: ", ")
        self.displayItems = [("Matrica ára", Int(vignette.cost)), ("Rendszerhasználati díj", Int(vignette.trxFee))]
        self.total = Int(vignette.sum)
    }

    init(vehicle: VehicleInfoResponse, counties: [County], countyVignette: HighwayVignette) {
        self.vehicle = vehicle
        self.orders = counties.map { HighwayOrder(type: $0.id, category: vehicle.type, cost: countyVignette.cost) }
        self.typeName = "Éves vármegyei"
        self.displayItems = counties.map { ($0.name, Int(countyVignette.cost)) } + [("Rendszerhasználati díj", Int(countyVignette.trxFee) * counties.count)]
        self.total = Int(countyVignette.sum) * counties.count
    }

    var isLoading = false
    var navigateToSuccess = false
    var showErrorAlert = false
    var errorMessage: String?

    func confirmPurchase() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await apiService.postHighwayOrder(HighwayOrderRequest(highwayOrders: orders))
            if response.statusCode == "OK" {
                navigateToSuccess = true
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

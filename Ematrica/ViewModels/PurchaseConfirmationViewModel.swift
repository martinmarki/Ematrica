//
//  PurchaseConfirmationViewModel.swift
//  Ematrica

import Foundation
import Observation

@Observable
@MainActor
final class PurchaseConfirmationViewModel {
    private let apiService: APIServiceProtocol
    let vehicle: VehicleInfoResponse
    let orders: [HighwayOrder]
    let typeName: String
    let displayItems: [(name: String, cost: Int)]
    let total: Int
    
    init(apiService: APIServiceProtocol, vehicle: VehicleInfoResponse, vignette: HighwayVignette) {
        self.apiService = apiService
        self.vehicle = vehicle
        self.orders = [HighwayOrder(type: vignette.vignetteType.first ?? "", category: vehicle.type, cost: vignette.cost)]
        self.typeName = vignette.vignetteType.map(\.vignetteDisplayName).joined(separator: ", ")
        self.displayItems = [("Matrica ára", Int(vignette.cost)), ("Rendszerhasználati díj", Int(vignette.trxFee))]
        self.total = Int(vignette.sum)
    }

    init(apiService: APIServiceProtocol, vehicle: VehicleInfoResponse, counties: [County], pricePerCounty: Int) {
        self.apiService = apiService
        self.vehicle = vehicle
        self.orders = counties.map { HighwayOrder(type: $0.id, category: vehicle.type, cost: Double(pricePerCounty)) }
        self.typeName = "Éves vármegyei"
        self.displayItems = counties.map { ($0.name, pricePerCounty) }
        self.total = counties.count * pricePerCounty
    }

    var isLoading = false
    var showSuccessAlert = false
    var showErrorAlert = false
    var errorMessage: String?

    func confirmPurchase() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await apiService.postHighwayOrder(HighwayOrderRequest(highwayOrders: orders))
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

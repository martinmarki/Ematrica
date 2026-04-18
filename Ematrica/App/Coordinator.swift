//
//  EmatricaApp.swift
//  Ematrica

import SwiftUI

enum PurchaseSelection: Hashable {
    case vignette(vehicle: VehicleInfoResponse, vignette: HighwayVignette)
    case counties(vehicle: VehicleInfoResponse, counties: [County], countyVignette: HighwayVignette)
}

enum Route: Hashable {
    case countySelection
    case purchaseConfirmation(PurchaseSelection)
    case purchaseSuccess
}

@Observable
@MainActor
final class Coordinator {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

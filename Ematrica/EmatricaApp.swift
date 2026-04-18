//
//  EmatricaApp.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 14..
//

import SwiftUI

@main
struct EmatricaApp: App {
    @State private var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                VignetteSelectionView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .countySelection:
                            CountySelectionView()
                        case .purchaseConfirmation(let selection):
                            PurchaseConfirmationView(selection: selection)
                        case .purchaseSuccess:
                            PurchaseSuccessView()
                        }
                    }
            }
            .environment(coordinator)
        }
    }
}

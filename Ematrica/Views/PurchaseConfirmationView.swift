//
//  PurchaseConfirmationView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 15..
//

import SwiftUI

struct PurchaseConfirmationView: View {
    @State private var viewModel: PurchaseConfirmationViewModel
    @Environment(Coordinator.self) private var coordinator

    init(selection: PurchaseSelection) {
        switch selection {
        case .vignette(let vehicle, let vignette):
            _viewModel = State(wrappedValue: PurchaseConfirmationViewModel(apiService: APIService(), vehicle: vehicle, vignette: vignette))
        case .counties(let vehicle, let counties, let countyVignette):
            _viewModel = State(wrappedValue: PurchaseConfirmationViewModel(apiService: APIService(), vehicle: vehicle, counties: counties, countyVignette: countyVignette))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(spacing: 15) {
                        SummaryRow(label: .licensePlate, value: viewModel.vehicle.plate.uppercased())
                        SummaryRow(label: .vignetteType, value: viewModel.typeName)
                    }
                    .padding(.top, 20)

                    Divider()
                        .padding(.vertical, 5)

                    VStack(spacing: 18) {
                        ForEach(viewModel.displayItems, id: \.name) { item in
                            ItemRow(name: item.name, price: item.cost)
                        }
                    }

                    Divider()
                        .padding(.vertical, 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(.amountToPay)
                            .font(.subheadline.bold())
                        Text("\(viewModel.total) Ft")
                            .font(.system(size: 38, weight: .bold))
                    }
                }
                .padding(.horizontal, 25)
            }
            
            VStack(spacing: 15) {
                Button(action: {
                    Task { await viewModel.confirmPurchase() }
                }) {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text(.continueButton).font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                .disabled(viewModel.isLoading)

                Button(action: { coordinator.pop() }) {
                    Text(.cancel)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color.primary, lineWidth: 2)
                        )
                        .foregroundColor(Color.primary)
                }
            }
            .padding(25)
            .background(Color.white)
        }
        .navigationTitle(.purchaseConfirmationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: viewModel.navigateToSuccess) { _, success in
            if success { coordinator.push(.purchaseSuccess) }
        }
        .alert(.error, isPresented: $viewModel.showErrorAlert) {
            Button(.ok, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct SummaryRow: View {
    let label: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

struct ItemRow: View {
    let name: String
    let price: Int
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
            Spacer()
            Text("\(price) Ft")
        }
    }
}
#Preview {
    NavigationStack {
        PurchaseConfirmationView(selection: .vignette(vehicle: .mock, vignette: .mocks[0]))
    }
    .environment(Coordinator())
}

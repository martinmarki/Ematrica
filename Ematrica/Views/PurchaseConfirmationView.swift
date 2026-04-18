//
//  PurchaseConfirmationView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 15..
//

import SwiftUI

struct PurchaseConfirmationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: PurchaseConfirmationViewModel

    init(vehicle: VehicleInfoResponse, vignette: HighwayVignette) {
        _viewModel = State(wrappedValue: PurchaseConfirmationViewModel(apiService: APIService(), vehicle: vehicle, vignette: vignette))
    }

    init(vehicle: VehicleInfoResponse, counties: [County], countyVignette: HighwayVignette) {
        _viewModel = State(wrappedValue: PurchaseConfirmationViewModel(apiService: APIService(), vehicle: vehicle, counties: counties, countyVignette: countyVignette))
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
                
                Button(action: {
                    dismiss()
                }) {
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
        .navigationBarBackButtonHidden(true)
        .navigationTitle(.purchaseConfirmationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $viewModel.navigateToSuccess) {
            PurchaseSuccessView()
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
    PurchaseConfirmationView(vehicle: .mock, vignette: .mocks[0])
}

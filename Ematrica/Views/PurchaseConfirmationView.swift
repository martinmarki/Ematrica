//
//  PurchaseConfirmationView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 15..
//

import SwiftUI

struct PurchaseConfirmationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = PurchaseConfirmationViewModel(apiService: APIService())

    let vehicle: VehicleInfoResponse
    let vignette: HighwayVignette

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(spacing: 15) {
                        SummaryRow(label: "Rendszám", value: vehicle.plate)
                        SummaryRow(label: "Matrica típusa", value: vignette.vignetteType.map(\.vignetteDisplayName).joined(separator: ", "))
                    }

                    Divider()
                        .padding(.vertical, 5)

                    VStack(spacing: 18) {
                        ItemRow(name: "Matrica ára", price: Int(vignette.cost))
                        ItemRow(name: "Rendszerhasználati díj", price: Int(vignette.trxFee))
                    }

                    Divider()
                        .padding(.vertical, 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fizetendő összeg")
                            .font(.subheadline.bold())

                        Text("\(Int(vignette.sum)) Ft")
                            .font(.system(size: 38, weight: .bold))
                    }
                }
                .padding(.horizontal, 25)
            }
            
            VStack(spacing: 15) {
                Button(action: {
                    Task { await viewModel.confirmPurchase(vehicle: vehicle, vignette: vignette) }
                }) {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Tovább").font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.02, green: 0.12, blue: 0.25))
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                .disabled(viewModel.isLoading)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Mégsem")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .stroke(Color(red: 0.02, green: 0.12, blue: 0.25), lineWidth: 2)
                        )
                        .foregroundColor(Color(red: 0.02, green: 0.12, blue: 0.25))
                }
            }
            .padding(25)
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Vásárlás megerősítése")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sikeres vásárlás", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {
                // TODO - navigate to successful purchase screen
                dismiss()
            }
        } message: {
            Text("A matricákat sikeresen kifizetted!")
        }
        .alert("Hiba", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

private extension String {
    var vignetteDisplayName: String {
        switch self {
        case "DAY":   return "D1 - napi (1 napos)"
        case "WEEK":  return "D1 - heti (10 napos)"
        case "MONTH": return "D1 - havi"
        default:      return self
        }
    }
}

struct SummaryRow: View {
    let label: String
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
                .foregroundColor(Color(red: 0.02, green: 0.12, blue: 0.25))
            Spacer()
            Text("\(price) Ft")
        }
    }
}
#Preview {
    PurchaseConfirmationView(vehicle: .mock, vignette: .mocks[0])
}

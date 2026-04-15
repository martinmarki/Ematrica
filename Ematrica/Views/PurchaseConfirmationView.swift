//
//  PurchaseConfirmationView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 15..
//

import SwiftUI

struct PurchaseConfirmationView: View {
    @Environment(\.dismiss) var dismiss

    private let vehicle = VehicleInfoResponse.mock
    private let counties = County.mocks
    private let vignette = HighwayVignette.mocks[0]

    private var total: Int {
        counties.count * Int(vignette.cost) + Int(vignette.trxFee)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(spacing: 15) {
                        SummaryRow(label: "Rendszám", value: vehicle.plate)
                        SummaryRow(label: "Matrica típusa", value: "Éves vármegyei")
                    }

                    Divider()
                        .padding(.vertical, 5)

                    VStack(spacing: 18) {
                        ForEach(counties) { county in
                            ItemRow(name: county.name, price: Int(vignette.cost))
                        }

                        ItemRow(name: "Rendszerhasználati díj", price: Int(vignette.trxFee))
                    }

                    Divider()
                        .padding(.vertical, 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fizetendő összeg")
                            .font(.subheadline.bold())

                        Text("\(total) Ft")
                            .font(.system(size: 38, weight: .bold))
                    }
                }
                .padding(.horizontal, 25)
            }
            
            VStack(spacing: 15) {
                Button(action: {
                    // TODO
                }) {
                    Text("Tovább")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.02, green: 0.12, blue: 0.25))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                
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
    PurchaseConfirmationView()
}

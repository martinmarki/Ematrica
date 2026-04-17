//
//  CountySelectionView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 14..
//

import SwiftUI

struct CountySelectionView: View {
    @State private var viewModel = CountySelectionViewModel(apiService: APIService())

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.counties) { county in
                        HStack {
                            Image(systemName: viewModel.selectedIDs.contains(county.id) ? "checkmark.square.fill" : "square")
                                .foregroundColor(.gray)
                            Text(county.name)
                                .foregroundColor(viewModel.selectedIDs.contains(county.id) ? .gray : .primary)
                            Spacer()
                            Text("\(Int(viewModel.countyVignette?.sum ?? 0)) Ft")
                                .foregroundColor(Color(red: 0.05, green: 0.1, blue: 0.2))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.selectedIDs.contains(county.id) {
                                viewModel.selectedIDs.remove(county.id)
                            } else {
                                viewModel.selectedIDs.insert(county.id)
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading) {
                Text("Fizetendő összeg").font(.caption).bold()
                Text("\(viewModel.totalAmount) Ft")
                    .padding(.top, 4)
                    .font(.system(size: 34, weight: .bold))

                Button(action: { viewModel.onNextTapped() }) {
                    Text("Tovább")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding()
            .background(Color.white)
        }
        .navigationTitle("Éves vármegyei matricák")
        .overlay { if viewModel.isLoading { ProgressView() } }
        .task { await viewModel.load() }
        .alert("Nincs kiválasztott vármegye", isPresented: $viewModel.showNoSelectionAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Kérjük válasszon legalább egy vármegyét a folytatáshoz.")
        }
        .navigationDestination(isPresented: $viewModel.navigateToConfirmation) {
            if let vehicle = viewModel.vehicle, let countyVignette = viewModel.countyVignette {
                PurchaseConfirmationView(
                    vehicle: vehicle,
                    counties: viewModel.selectedCounties,
                    countyVignette: countyVignette
                )
            }
        }
    }
}

#Preview {
    CountySelectionView()
}

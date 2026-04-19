//
//  CountySelectionView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 14..
//

import SwiftUI

struct CountySelectionView: View {
    @State private var viewModel = CountySelectionViewModel()
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        VStack {
            List {
                Section {
                    Image("HU_county")
                        .resizable()
                        .scaledToFit()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                }

                Section {
                    ForEach(viewModel.counties) { county in
                        HStack {
                            Image(systemName: viewModel.selectedIDs.contains(county.id) ? "checkmark.square.fill" : "square")
                                .foregroundColor(.gray)
                            Text(county.name)
                                .foregroundColor(viewModel.selectedIDs.contains(county.id) ? .gray : .primary)
                            Spacer()
                            Text("\(Int(viewModel.countyVignette?.cost ?? 0)) Ft")
                                .foregroundColor(Color.primary)
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
            .scrollContentBackground(.hidden)

            if !viewModel.isSelectionConnected {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(.countiesNotConnectedWarning)
                        .font(.footnote)
                }
                .foregroundColor(.orange)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.orange.opacity(0.1))
            }

            VStack(alignment: .leading) {
                Text(.amountToPay).font(.caption).bold()
                Text("\(viewModel.totalAmount) Ft")
                    .padding(.top, 4)
                    .font(.system(size: 34, weight: .bold))

                Button(action: {
                    guard let vehicle = viewModel.vehicle, let countyVignette = viewModel.countyVignette else { return }
                    coordinator.push(.purchaseConfirmation(.counties(
                        vehicle: vehicle,
                        counties: viewModel.selectedCounties,
                        countyVignette: countyVignette
                    )))
                }) {
                    Text(.continueButton)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedIDs.isEmpty ? Color.disabled : Color.primary)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .disabled(viewModel.selectedIDs.isEmpty)
            }
            .padding()
            .background(Color.white)
        }
        .navigationTitle(.annualCountyVignettes)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay { if viewModel.isLoading { ProgressView() } }
        .task { await viewModel.load() }
    }
}

#Preview {
    NavigationStack {
        CountySelectionView()
    }
    .environment(Coordinator())
}

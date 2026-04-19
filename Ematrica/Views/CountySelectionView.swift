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
                /*
                 Térkép Implementációs Terv

                 A Figma dizájnban szereplő térkép exportálása korlátozott volt, mivel a Developer Mode használatához és az elemek exportálásához további jogosultságok lettek volna szükségesek. Emiatt a következők szerint valósítanám meg:

                 SVG-to-SwiftUI: A vármegyék határait reprezentáló geometriai adatokat (Path data) vármegyénként különálló SwiftUI Shape objektumokká alakítanám.

                 A megyéket egy ZStack struktúrába rendezném, ahol az API-ból érkező egyedi azonosítók (pl. YEAR_11) alapján történne a renderelés.

                 Kiválasztott megye: A isSelected állapot hatására a terület színe dinamikusan változna (pl. .fill(Color.green)).

                 Kétirányú szinkron: A térképen való kattintás (onTapGesture) ugyanazt a logikai eseményt váltaná ki a ViewModel-ben, mint a listaelem kiválasztása, így a UI minden eleme azonnal frissülne.
                */
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

                PrimaryButton(label: .continueButton, isDisabled: viewModel.selectedIDs.isEmpty) {
                    guard let vehicle = viewModel.vehicle, let countyVignette = viewModel.countyVignette else { return }
                    coordinator.push(.purchaseConfirmation(.counties(
                        vehicle: vehicle,
                        counties: viewModel.selectedCounties,
                        countyVignette: countyVignette
                    )))
                }
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

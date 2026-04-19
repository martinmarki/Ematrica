//
//  VignetteSelectionView.swift
//  Ematrica

import SwiftUI

struct VignetteSelectionView: View {
    @State private var viewModel = VignetteSelectionViewModel()
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: 20) {
            if let vehicle = viewModel.vehicle {
                HStack {
                    Image(systemName: "car.fill")
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(vehicle.plate.uppercased())
                            .font(.headline)
                        Text(vehicle.name)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }

            if viewModel.isUnavailable {
                ContentUnavailableView(
                    String(localized: "Nem elérhetők a matricaadatok"),
                    systemImage: "exclamationmark.triangle",
                    description: Text(.vignettesUnavailableMessage)
                )
                .frame(maxWidth: .infinity)
                .padding()
                .cornerRadius(15)
            } else {
                VStack(alignment: .leading, spacing: 15) {
                    Text(.nationalVignettes)
                        .font(.title3)
                        .bold()

                    ForEach(viewModel.nationalVignettes, id: \.vignetteType) { option in
                        HStack {
                            Circle()
                                .strokeBorder(viewModel.selectedVignette == option.vignetteType ? Color.primary : Color.gray, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().fill(viewModel.selectedVignette == option.vignetteType ? Color.primary : Color.clear).frame(width: 12, height: 12))

                            Text(option.vignetteType.map(\.vignetteDisplayName).joined(separator: ", "))
                            Spacer()
                            Text("\(Int(option.cost)) Ft")
                                .bold()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(viewModel.selectedVignette == option.vignetteType ? Color.primary : Color.gray.opacity(0.3)))
                        .onTapGesture {
                            viewModel.selectedVignette = option.vignetteType
                        }
                    }

                    Button(action: {
                        guard let vehicle = viewModel.vehicle, let vignette = viewModel.selectedVignetteOption else { return }
                        coordinator.push(.purchaseConfirmation(.vignette(vehicle: vehicle, vignette: vignette)))
                    }) {
                        Text(.purchase)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.selectedVignetteOption == nil ? Color.disabled : Color.primary)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .disabled(viewModel.selectedVignetteOption == nil)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
            }

            if !viewModel.isUnavailable {
                Button(action: { coordinator.push(.countySelection) }) {
                    HStack {
                        Text(.annualCountyVignettes)
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(15)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle(.eVignette)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay {
            if viewModel.isLoading { ProgressView() }
        }
        .task { await viewModel.load() }
        .onAppear {
            viewModel.selectedVignette = nil
        }
    }
}

#Preview {
    NavigationStack {
        VignetteSelectionView()
    }
    .environment(Coordinator())
}

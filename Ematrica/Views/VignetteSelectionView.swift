//
//  VignetteSelectionView.swift
//  Ematrica

import SwiftUI

struct VignetteSelectionView: View {
    @State private var viewModel = VignetteSelectionViewModel(apiService: APIService())

    var body: some View {
        NavigationStack {
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

                VStack(alignment: .leading, spacing: 15) {
                    Text("Országos matricák")
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
                    
                    Button(action: { viewModel.navigateToConfirmation = true }) {
                        Text("Vásárlás")
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
                
                NavigationLink(destination: CountySelectionView()) {
                    HStack {
                        Text("Éves vármegyei matricák")
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
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("E-matrica")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navigationBar, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .overlay {
                if viewModel.isLoading { ProgressView() }
            }
            .task { await viewModel.load() }
            .navigationDestination(isPresented: $viewModel.navigateToConfirmation) {
                if let vehicle = viewModel.vehicle, let vignette = viewModel.selectedVignetteOption {
                    PurchaseConfirmationView(vehicle: vehicle, vignette: vignette)
                }
            }
            .onAppear {
                viewModel.selectedVignette = nil
            }
        }
    }
}

#Preview {
    VignetteSelectionView()
}

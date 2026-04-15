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
                            Text(vehicle.plate)
                                .font(.headline)
                            Text(vehicle.name)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }

                VStack(alignment: .leading, spacing: 15) {
                    Text("Országos matricák")
                        .font(.title3)
                        .bold()

                    ForEach(viewModel.nationalVignettes, id: \.vignetteType) { option in
                        HStack {
                            Circle()
                                .strokeBorder(viewModel.selectedVignette == option.vignetteType ? Color.blue : Color.gray, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().fill(viewModel.selectedVignette == option.vignetteType ? Color.blue : Color.clear).frame(width: 12, height: 12))

                            Text(option.vignetteType.map(\.vignetteDisplayName).joined(separator: ", "))
                            Spacer()
                            Text("\(Int(option.sum)) Ft")
                                .bold()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(viewModel.selectedVignette == option.vignetteType ? Color.blue : Color.gray.opacity(0.3)))
                        .onTapGesture {
                            viewModel.selectedVignette = option.vignetteType
                        }
                    }
                    
                    Button(action: {
                        if viewModel.selectedVignetteOption != nil {
                            viewModel.navigateToConfirmation = true
                        } else {
                            viewModel.showNoSelectionAlert = true
                        }
                    }) {
                        Text("Vásárlás")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                NavigationLink(destination: CountySelectionView()) {
                    HStack {
                        Text("Éves vármegyei matricák")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("E-matrica")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if viewModel.isLoading { ProgressView() }
            }
            .task { await viewModel.load() }
            .alert("Nincs kiválasztott matrica", isPresented: $viewModel.showNoSelectionAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Kérjük válasszon matricát a folytatáshoz.")
            }
            .navigationDestination(isPresented: $viewModel.navigateToConfirmation) {
                if let vehicle = viewModel.vehicle, let vignette = viewModel.selectedVignetteOption {
                    PurchaseConfirmationView(vehicle: vehicle, vignette: vignette)
                }
            }
        }
    }
}

#Preview {
    VignetteSelectionView()
}

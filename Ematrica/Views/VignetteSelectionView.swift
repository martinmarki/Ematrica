//
//  VignetteSelectionView.swift
//  Ematrica

import SwiftUI

struct VignetteSelectionView: View {
    @State private var selectedVignette: [String]?

    let vehicle = VehicleInfoResponse.mock
    let nationalOptions = HighwayVignette.mocks
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Országos matricák")
                        .font(.title3)
                        .bold()
                    
                    ForEach(nationalOptions, id: \.vignetteType) { option in
                        HStack {
                            Circle()
                                .strokeBorder(selectedVignette == option.vignetteType ? Color.blue : Color.gray, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().fill(selectedVignette == option.vignetteType ? Color.blue : Color.clear).frame(width: 12, height: 12))

                            Text(option.vignetteType.map(\.vignetteDisplayName).joined(separator: ", "))
                            Spacer()
                            Text("\(Int(option.sum)) Ft")
                                .bold()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(selectedVignette == option.vignetteType ? Color.blue : Color.gray.opacity(0.3)))
                        .onTapGesture {
                            selectedVignette = option.vignetteType
                        }
                    }
                    
                    Button(action: {
                        // TODO
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

#Preview {
    VignetteSelectionView()
}

//
//  CountySelectionView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 14..
//

import SwiftUI

struct CountySelectionView: View {
    let counties: [County] = County.mocks
    @State private var selectedIDs: Set<String> = []

    private let countyVignettePrice = 5450
    var totalCountyAmount: Int {
        selectedIDs.count * 5450
    }

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(counties) { county in
                        HStack {
                            Image(systemName: selectedIDs.contains(county.id) ? "checkmark.square.fill" : "square")
                                .foregroundColor(.gray)
                            Text(county.name)
                                .foregroundColor(selectedIDs.contains(county.id) ? .gray : .primary)
                            Spacer()
                            Text("\(countyVignettePrice) Ft")
                                .foregroundColor(Color(red: 0.05, green: 0.1, blue: 0.2))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedIDs.contains(county.id) {
                                selectedIDs.remove(county.id)
                            } else {
                                selectedIDs.insert(county.id)
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading) {
                Text("Fizetendő összeg").font(.caption).bold()
                Text("\(totalCountyAmount) Ft")
                    .padding(.top, 4)
                    .font(.system(size: 34, weight: .bold))

                Button("Tovább") {
                    // TODO
                }
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .padding()
            .background(Color.white)
        }
        .navigationTitle("Éves vármegyei matricák")
    }
}

#Preview {
    CountySelectionView()
}

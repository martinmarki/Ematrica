//
//  PurchaseSuccessView.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 16..
//

import SwiftUI

struct PurchaseSuccessView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .foregroundColor(Color(red: 0.02, green: 0.12, blue: 0.25))

            Text("A matricákat sikeresen kifizetted!")
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.navigationBar.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            Button(action: { dismiss() }) {
                Text("Rendben")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.02, green: 0.12, blue: 0.25))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(25)
        }
    }
}

#Preview {
    PurchaseSuccessView()
}

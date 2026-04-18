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
        ZStack(alignment: .top) {
            Color.navigationBar.ignoresSafeArea()

            Image("confetti")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                Spacer()

                Text(.purchaseSuccessMessage)
                    .font(.system(size: 44, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 24)

                Spacer()

                Image("successMan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.navigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            Button(action: { dismiss() }) {
                Text(.confirm)
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(25)
            .background(Color.navigationBar)
        }
    }
}

#Preview {
    PurchaseSuccessView()
}

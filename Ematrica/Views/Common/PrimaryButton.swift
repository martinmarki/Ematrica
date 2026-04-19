import SwiftUI

struct PrimaryButton: View {
    let label: LocalizedStringKey
    var isDisabled: Bool = false
    let action: () -> Void

    private var backgroundColor: Color {
        isDisabled ? Color.disabled : Color.primary
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
        .disabled(isDisabled)
    }
}

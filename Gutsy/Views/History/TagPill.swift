import SwiftUI

import SwiftUI

struct TagPill: View {
    let text: String
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.system(size: 10))
            Text(text).font(.system(size: 12, weight: .medium))
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark").font(.system(size: 9, weight: .bold))
                }.buttonStyle(.plain)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
    }
}

// Editing variant — same shape + icon, with a TextField inside
struct EditableTagPill: View {
    @Binding var text: String
    var placeholder: String = "Add Tag"
    let onCommit: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.system(size: 10))
            TextField(placeholder, text: $text)
                .font(.system(size: 12, weight: .medium))
                .focused($focused)
                .fixedSize()                 // pill hugs the text
                .onSubmit(onCommit)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
        .onAppear { focused = true }
    }
}

#Preview {
    VStack(spacing: 8) {
        TagPill(text: "Healthy Meal")
        TagPill(text: "Healthy", onRemove: {})
    }
    .padding()
    .background(Color(.systemGray6))
}

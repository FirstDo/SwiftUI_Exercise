import SwiftUI

enum InternetState: String, CaseIterable {
  case loading
  case success
  case error
}

struct OptionalModifierView: View {
  @State private var state: InternetState = .loading
  
  var body: some View {
    VStack(spacing: 30) {
      Picker("", selection: $state) {
        ForEach(InternetState.allCases, id: \.rawValue) {
          Text($0.rawValue)
            .tag($0)
        }
      }
      .pickerStyle(.segmented)
      
      Image(systemName: "wifi.circle.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .modifiers {
          switch state {
          case .loading: $0.foregroundStyle(.blue)
          case .success: $0.foregroundStyle(.green)
          case .error: $0.foregroundStyle(.red)
          }
        }
    }
  }
}

extension View {
  func modifiers<Content: View>(
    @ViewBuilder content: @escaping (Self) -> Content
  ) -> some View {
    content(self)
  }
}

#Preview {
  OptionalModifierView()
}

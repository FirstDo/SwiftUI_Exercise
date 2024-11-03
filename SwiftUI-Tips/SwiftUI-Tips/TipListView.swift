import SwiftUI

enum ViewInfo: CaseIterable, Identifiable {
  case optionalModifier
  
  var id: UUID { return UUID() }
  
  var view: some View {
    switch self {
    case .optionalModifier: return OptionalModifierView()
    }
  }
  
  var title: String {
    switch self {
    case .optionalModifier: return "OptionalModifier"
    }
  }
}

struct TipListView: View {
  private let views = ViewInfo.allCases
  
  var body: some View {
    NavigationStack {
      List(views) { data in
        NavigationLink(data.title, value: data)
      }
      .navigationDestination(for: ViewInfo.self) { data in
        data.view
      }
      .navigationTitle("List")
    }
  }
}

#Preview {
  TipListView()
}

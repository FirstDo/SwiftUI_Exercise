import SwiftUI

enum ViewInfo: CaseIterable, Identifiable {
  case optionalModifier
  case infiniteScrollView
  case alertDialog
  case customSlider
  
  var id: UUID { return UUID() }
  
  @ViewBuilder
  var view: some View {
    switch self {
    case .optionalModifier:
      OptionalModifierView()
    case .infiniteScrollView:
      InfiniteScrollView()
    case .alertDialog:
      AlertDialogView()
    case .customSlider:
      CustomSliverView()
    }
  }
  
  var title: String {
    switch self {
    case .optionalModifier: return "OptionalModifier"
    case .infiniteScrollView: return "InfiniteScrollView"
    case .alertDialog: return "AlertDialog"
    case .customSlider: return "CustomSlider"
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

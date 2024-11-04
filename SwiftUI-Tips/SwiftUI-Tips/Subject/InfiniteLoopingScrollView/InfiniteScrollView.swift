import SwiftUI

// - Model
struct Item: Identifiable {
  var id = UUID()
  var color: Color
}

// - Views

struct InfiniteScrollView: View {
  @State private var items: [Item] = [
    Color.red, .blue, .green, .yellow, .black
  ].compactMap { .init(color: $0) }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack {
        GeometryReader {
          let size = $0.size
          
          LoopingScrollView(width: size.width, spacing: 0, items: items) { item in
            RoundedRectangle(cornerRadius: 15)
              .fill(item.color.gradient)
              .padding(.horizontal, 15)
          }
          .scrollTargetBehavior(.paging)
        }
        .frame(height: 250)
      }
      .padding(.vertical, 15)
    }
    .scrollIndicators(.hidden)
    .navigationTitle("Infiite Scroll")
  }
}

private struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
  let width: CGFloat
  let spacing: CGFloat
  let items: Item
  
  @ViewBuilder var content: (Item.Element) -> Content
 
  var body: some View {
    GeometryReader {
      let size = $0.size
      let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
      
      ScrollView(.horizontal) {
        LazyHStack(spacing: spacing) {
          ForEach(items) { item in
            content(item)
              .frame(width: width)
          }
          
          ForEach(0..<repeatingCount, id: \.self) { index in
            let item = Array(items)[index % items.count]
            
            content(item)
              .frame(width: width)
          }
        }
        .background(
          ScrollViewHelper(
            width: width,
            spacing: spacing,
            itemsCount: items.count,
            repeatingCount: repeatingCount
          )
        )
      }
    }
  }
}

private struct ScrollViewHelper: UIViewRepresentable {
  let width: CGFloat
  let spacing: CGFloat
  let itemsCount: Int
  let repeatingCount: Int
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(width: width, spacing: spacing, itemsCount: itemsCount, repeatingCount: repeatingCount)
  }
  
  func makeUIView(context: Context) -> UIView {
    return .init()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
      if let scrollView = uiView.superview?.superview?.superview as? UIScrollView,
         context.coordinator.isAdded == false
      {
        scrollView.delegate = context.coordinator
        context.coordinator.isAdded = true
      }
    }
    
    context.coordinator.width = width
    context.coordinator.spacing = spacing
    context.coordinator.itemsCount = itemsCount
    context.coordinator.repeatingCount = repeatingCount
    
  }
  
  class Coordinator: NSObject, UIScrollViewDelegate {
    var width: CGFloat
    var spacing: CGFloat
    var itemsCount: Int
    var repeatingCount: Int
    var isAdded = false
   
    init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
      self.width = width
      self.spacing = spacing
      self.itemsCount = itemsCount
      self.repeatingCount = repeatingCount
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      guard itemsCount > 0 else { return }
      
      let minX = scrollView.contentOffset.x
      let mainContentSize = CGFloat(itemsCount) * width
      let spacingSize = CGFloat(itemsCount) * spacing
      
      if minX > (mainContentSize + spacingSize) {
        scrollView.contentOffset.x -= (mainContentSize + spacing)
        print(scrollView.contentOffset.x)
      }
      
      if minX < 0 {
        scrollView.contentOffset.x += (mainContentSize + spacingSize)
        print(scrollView.contentOffset.x)
      }
    }
  }
}

#Preview {
  NavigationStack {
    InfiniteScrollView()
  }
}

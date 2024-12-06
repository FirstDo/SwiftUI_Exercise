import SwiftUI

final class RouterA: Router {
  enum Destination: Identifiable {
    case a2
    case a3
    case b
    
    var id: Self { self }
  }
  
  @Published var path = [Destination]()
  @Published var isPresented: Destination?
}

struct AFlowCoordinatorView: View {
  @StateObject var router = RouterA()

  var body: some View {
    NavigationStack(path: $router.path) {
      AView()
        .navigationDestination(for: RouterA.Destination.self) { destination in
          switch destination {
          case .a2:
            A2View()
          case .a3:
            A3View()
          case .b:
            fatalError()
          }
        }
    }
    .sheet(item: $router.isPresented) { destination in
      switch destination {
      case .a2, .a3:
        fatalError()
      case .b:
        BView()
      }
    }
    .environmentObject(router)
  }
}

struct AView: View {
  @EnvironmentObject var router: RouterA
  
  var body: some View {
    VStack {
      Text("A View")
      Button("Push A2") {
        router.push(.a2)
      }
      Button("Present B") {
        router.present(.b)
      }
    }
  }
}

struct A2View: View {
  @EnvironmentObject var router: RouterA
  
  var body: some View {
    VStack {
      Text("A2 View")
      Button("Pop") {
        router.pop()
      }
      Button("Push A3") {
        router.push(.a3)
      }
    }
  }
}

struct A3View: View {
  @EnvironmentObject var router: RouterA
  
  var body: some View {
    VStack {
      Text("A3 View")
      Button("Pop") {
        router.pop()
      }
      Button("PopToA2") {
        router.pop(to: .a2)
      }
      Button("PopToRoot") {
        router.popToRoot()
      }
    }
  }
}

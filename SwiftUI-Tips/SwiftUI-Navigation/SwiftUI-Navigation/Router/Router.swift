import SwiftUI

protocol Router: ObservableObject {
  associatedtype Destination: Hashable, Identifiable
  
  var path: [Destination] { get set }
  var isPresented: Destination? { get set }
}

extension Router {
  func push(_ destination: Destination) {
    path.append(destination)
  }
  
  func pop() {
    if path.isEmpty { return }
    path.removeLast()
  }
  
  func popToRoot() {
    if path.isEmpty { return }
    path.removeAll()
  }
  
  func pop(to destination: Destination) {
    if path.isEmpty || !path.contains(destination) { return }
    while let top = path.last, destination != top {
      path.removeLast()
    }
  }
  
  func present(_ destination: Destination) {
    isPresented = destination
  }
  
  func dismiss() {
    isPresented = nil
  }
}

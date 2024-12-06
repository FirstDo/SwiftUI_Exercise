import SwiftUI

struct BView: View {
  @EnvironmentObject var router: RouterA
  
  var body: some View {
    VStack {
      Text("B View")
      Button("Dismiss") {
        router.dismiss()
      }
    }
  }
}


import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack(spacing: 70) {
      ZStack {
        Color.red
          .frame(width: 100, height: 100)
        
        Color.blue
          .frame(width: 100, height: 100)
          .offset(x: 30, y: 30)
        
        Color.green
          .frame(width: 100, height: 100)
          .offset(x: 60, y: 60)
      }
      .compositingGroup()
      .opacity(0.5)
      
      
      ZStack {
        Color.red
          .frame(width: 100, height: 100)
        
        Color.blue
          .frame(width: 100, height: 100)
          .offset(x: 30, y: 30)
        
        Color.green
          .frame(width: 100, height: 100)
          .offset(x: 60, y: 60)
      }
      .opacity(0.5)
    }
  }
}

#Preview {
  ContentView()
}

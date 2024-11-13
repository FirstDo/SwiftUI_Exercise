import SwiftUI

struct LimitedTextFieldView: View {
  @State private var text: String = ""
  
  var body: some View {
    VStack {
      LimitedTextField(
        config: .init(
          limit: 40,
          tint: .secondary,
          autoResizes: true
        ),
        hint: "Type here",
        value: $text
      )
      .frame(maxHeight: 150)
    }
    .padding()
    .navigationTitle("Limited TextField")
  }
}

struct LimitedTextField: View {
  var config: Config
  var hint: String
  @Binding var value: String
  
  @FocusState private var isKeyboardShowing: Bool
  
  var body: some View {
    VStack(
      alignment: config.progressConfig.alignment,
      spacing: 12
    ) {
      ZStack(alignment: .top) {
        RoundedRectangle(cornerRadius: config.borderConfig.radius)
          .fill(.clear)
          .frame(height: config.autoResizes ? 0: nil)
          .contentShape(.rect(cornerRadius: config.borderConfig.radius))
          .onTapGesture {
            isKeyboardShowing = true
          }
        
        TextField(hint, text: $value, axis: .vertical)
          .focused($isKeyboardShowing)
          .onChange(of: value) { oldValue, newValue in
            guard !config.allowsExcessTyping else { return }
            value = String(value.prefix(config.limit))
          }
      }
      .padding(.horizontal, 15)
      .padding(.vertical, 10)
      .background(
        RoundedRectangle(cornerRadius: config.borderConfig.radius)
          .stroke(progressColor.gradient, lineWidth: config.borderConfig.width)
      )
      
      // Progress Bar / Text Indicator
      HStack(alignment: .top, spacing: 12) {
        if config.progressConfig.showRing {
          ZStack {
            Circle()
              .stroke(.ultraThinMaterial, lineWidth: 5)
            
            Circle()
              .trim(from: 0, to: progress)
              .stroke(progressColor.gradient, lineWidth: 5)
              .rotationEffect(.init(degrees: -90))
          }
          .frame(width: 20, height: 20)
        }
        
        if config.progressConfig.showsText {
          Text("\(value.count)/\(config.limit)")
            .foregroundStyle(progressColor.gradient)
        }
      }
    }
  }
  
  var progress: CGFloat {
    return max(min(CGFloat(value.count) / CGFloat(config.limit), 1), 0)
  }
  
  var progressColor: Color {
    return progress < 0.6 ? config.tint : progress == 1.0 ? .red : .orange
  }
  
  struct Config {
    var limit: Int
    var tint: Color = .blue
    var autoResizes: Bool = false
    var allowsExcessTyping: Bool = false
    var progressConfig = ProgressConfig()
    var borderConfig = BorderConfig()
  }
  
  struct ProgressConfig {
    var showRing = true
    var showsText = false
    var alignment: HorizontalAlignment = .trailing
  }
  
  struct BorderConfig {
    var show = false
    var radius: CGFloat = 12
    var width: CGFloat = 0.8
  }
}

#Preview {
  NavigationStack {
    LimitedTextFieldView()
  }
}

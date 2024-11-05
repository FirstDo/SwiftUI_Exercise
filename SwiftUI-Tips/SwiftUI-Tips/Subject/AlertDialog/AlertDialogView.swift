import SwiftUI

struct AlertDialogView: View {
  @State private var showPopup = false
  var body: some View {
    Button("toggle") {
      showPopup.toggle()
    }
    .popView(isPresented: $showPopup) {
      
    } content: {
      CustomAlertView {
        showPopup.toggle()
      }
    }
  }
}

#Preview {
  AlertDialogView()
}

private extension View {
  @ViewBuilder
  func popView<Content: View>(
    isPresented: Binding<Bool>,
    onDismiss: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      PopViewHelper(isPresented: isPresented, onDismiss: onDismiss, viewContent: content)
    )
  }
}

private struct PopViewHelper<ViewContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let onDismiss: () -> Void
  @ViewBuilder let viewContent: ViewContent
  
  @State private var presentFullScreenCover = false
  @State private var animateView = false
  
  func body(content: Content) -> some View {
    let screenHeight = screenSize.height
    let animateView = animateView
    
    content
      .fullScreenCover(isPresented: $presentFullScreenCover, onDismiss: onDismiss) {
        ZStack {
          Rectangle()
            .fill(Color.black.opacity(0.25))
            .ignoresSafeArea()
            .opacity(animateView ? 1 : 0)
          
          viewContent
            .padding(.horizontal, 20)
            .visualEffect({ content, proxy in
              content
                .offset(y: offset(proxy, screenHeight: screenHeight, animateView: animateView))
            })
            .presentationBackground(.clear)
            .task {
              guard animateView == false else { return }
              withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                self.animateView = true
              }
            }
        }
      }
      .transaction {
        $0.disablesAnimations = true
      }
      .onChange(of: isPresented) { oldValue, newValue in
        if newValue {
          presentFullScreenCover = newValue
        } else {
          Task {
            withAnimation(.snappy(duration: 0.45, extraBounce: 0)) {
              self.animateView = false
            }
            
            try? await Task.sleep(for: .seconds(0.45))
            presentFullScreenCover = newValue
          }
        }
      }
  }
  
  nonisolated private func offset(
    _ proxy: GeometryProxy,
    screenHeight: CGFloat,
    animateView: Bool
  ) -> CGFloat {
    let viewHeight = proxy.size.height
    return animateView ? 0 : (screenHeight + viewHeight) / 2
  }
  
  private var screenSize: CGSize {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
      .screen.bounds.size ?? .zero
  }
}

private struct CustomAlertView: View {
  let onTap: () -> Void
  
  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "star.fill")
        .resizable()
        .frame(width: 50, height: 50)
      
      Text("대충 얼럿의 내용이 적히는 부분...!!")
      
      HStack {
        Button(action: onTap) {
          Text("취소")
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background {
              RoundedRectangle(cornerRadius: 12)
                .fill(.red.gradient)
            }
        }
        
        Button(action: onTap) {
          Text("확인")
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background {
              RoundedRectangle(cornerRadius: 12)
                .fill(.blue.gradient)
            }
        }
      }
    }
    .padding(30)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(.white)
    )
  }
}

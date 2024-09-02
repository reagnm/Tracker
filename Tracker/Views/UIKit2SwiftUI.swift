//
//  UIKit2SwiftUI.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import SwiftUI
import Swiftagram
import Combine

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

//internal struct LoginView: View {
//    @Binding var secret: Secret?
//    @State private var cancellables: Set<AnyCancellable> = []
//    
//    var body: some View {
//        VStack {
//            
//        }
//        .onAppear {
//            Authenticator.transient
//#if(macOS)
//                .visual(filling: NSApp.mainWindow?.contentView)
//#endif
//                .visual(filling: UIView)
//                .sink(receiveCompletion: { _ in
//                }, receiveValue: { receivedSecret in secret = receivedSecret })
//                .store(in: &cancellables)
//        }
//    }
//    
//    init(_ secret: Binding<Secret>? = nil) {
//        self.secret = secret?.wrappedValue
//    }
//}


//internal struct LoginSwiftUI: View {
//    @State var isPresentingLoginView: Bool = false
//    @State var secret: Secret?
//
//    var body: some View {
//        VStack {
//            Image("Header")
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal, 50)
//
//            if let secret = secret, let token = secret.token {
//                Text(token)
//                    .font(Font.headline.smallCaps())
//                    .foregroundColor(.primary)
//                    .lineLimit(3)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .onTapGesture { UIPasteboard.general.string = token }
//
//                Text("(Tap to copy it to your clipboard)")
//                    .font(.caption)
//                    .fixedSize(horizontal: false, vertical: true)
//            } else {
//                // The disclaimer.
//                Text.combine(
//                    Text("Please authenticate with your "),
//                    Text("Instagram").bold(),
//                    Text(" account to receive a token for "),
//                    Text("SwiftagramTests").bold()
//                )
//                .fixedSize(horizontal: false, vertical: true)
//
//                // Login.
//                Button {
//                    isPresentingLoginView = true
//                } label: {
//                    Text("Authenticate").font(.headline)
//                }
//                .foregroundColor(.accentColor)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding(.vertical)
//                .padding(.horizontal, 50)
//                .sheet(isPresented: $isPresentingLoginView) {
//                    LoginView(secret: $secret)
//                }
//            }
//        }
//    }
//}

internal struct LoginSwiftUI: View {
    /// Whether it should present the login view or not.
    @State var isPresentingLoginView: Bool = false
    /// The current secret.
    @State var secret: Secret?
    
//    init(_ isPresentingLoginView: Bool = false, _ secret: Binding<Secret?>) {
//        self._isPresentingLoginView = State(initialValue: isPresentingLoginView)
//        self._secret = secret
//    }

    /// The actual view.
    var body: some View {
        VStack(spacing: 40) {
            // The header.
            Image(systemName:"person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 50)
            // Check for token.
            if let secret = secret, let token = secret.token {
                Text(token)
                    .font(Font.headline.smallCaps())
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                #if canImport(AppKit)
                    .onTapGesture { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(token, forType: .string) }
                #else
                    .onTapGesture { UIPasteboard.general.string = token }
                #endif
                
                Text("(Tap to copy it in your clipboard)")
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                // The disclaimer.
                Text.combine(
                    Text("Please authenticate with your "),
                    Text("Instagram").bold(),
                    Text(" account to receive a token for "),
                    Text("SwiftagramTests").bold()
                )
                .fixedSize(horizontal: false, vertical: true)
                // Login.
                .fixedSize(horizontal: false, vertical: true)
                // Login.
                Button {
                    isPresentingLoginView = true
                } label: {
                    Text("Authenticate").font(.headline)
                }.foregroundColor(.accentColor)
            }
        }
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
        .padding(.horizontal, 50)
        .sheet(isPresented: $isPresentingLoginView) {
            #if(iOS)
            LoginView(secret: $secret)
            #else
            LoginSwiftUI(
                isPresentingLoginView: isPresentingLoginView,
                secret: $secret.wrappedValue
            )
            #endif
        }
        
        var isPresentingLoginBinding: Binding<Bool> {
            Binding(
                get: { isPresentingLoginView },
                set: { isPresentingLoginView = $0 }
            )
        }
    }
}


#Preview {
    LoginSwiftUI()
}


//
//  LoginView.swift
//  Tracker
//
//  Created by Christian Norton on 9/1/24.
//

import Foundation
import Swiftagram
import SwiftUI
import SwiftData

#if(canImport(UIKit))
import UIKit

internal class LoginViewController: UIViewController {
    private var bin: Set<AnyCancellable> = []
    var completion: ((Secret) -> Void)? {
        didSet {
            guard oldValue == nil, let completion = completion else { return }
            // Authenticate.
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                Authenticator.transient
                    .visual(filling: self.view)
                    .authenticate()
                    .sink(receiveCompletion: { _ in self.dismiss(animated: true, completion: nil) },
                          receiveValue: completion)
                    .store(in: &self.bin)
            }
        }
    }
}


struct LoginView: UIViewControllerRepresentable {
    @Binding var secret: Secret?
    
    func makeUIViewController(context: Context) -> LoginViewController {
        let controller = LoginViewController()
        controller.completion = { secret = $0 }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
    }
}
#endif


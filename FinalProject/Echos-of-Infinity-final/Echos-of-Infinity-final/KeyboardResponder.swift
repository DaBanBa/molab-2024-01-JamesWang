//
//  KeyboardObserver.swift
//  Echos-of-Infinity-final
//
//  Created by James Wang on 12/5/24.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var notificationCenter: NotificationCenter
    private var cancellables = Set<AnyCancellable>()

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        self.notificationCenter.addObserver(self,
                                             selector: #selector(keyboardWillShow(_:)),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        self.notificationCenter.addObserver(self,
                                             selector: #selector(keyboardWillHide(_:)),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            DispatchQueue.main.async {
                self.currentHeight = frame.height
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.currentHeight = 0
        }
    }
}

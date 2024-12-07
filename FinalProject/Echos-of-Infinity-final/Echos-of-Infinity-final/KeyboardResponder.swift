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
    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification -> CGFloat? in
                guard let userInfo = notification.userInfo else { return nil }
                let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                return notification.name == UIResponder.keyboardWillHideNotification ? 0 : endFrame.height
            }
            .assign(to: \.currentHeight, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}

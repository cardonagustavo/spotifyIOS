//
//  KeyboardManager.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero 16/02/24.
//

import UIKit

protocol KeyboardManagerDelegate: AnyObject {
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillShowWith info: KeyboardManager.Information)
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillHideWith info: KeyboardManager.Information)
}

class KeyboardManager {
    private unowned var delegate: KeyboardManagerDelegate?
    
    init(delegate: KeyboardManagerDelegate) {
        self.delegate = delegate
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let info = Information(userInfo: notification.userInfo)
        self.delegate?.keyboardManager(self, keyboardWillShowWith: info)
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let info = Information(userInfo: notification.userInfo)
        self.delegate?.keyboardManager(self, keyboardWillHideWith: info)
    }
}

extension KeyboardManager {
    struct Information {
        let frame: CGRect
        let animationDuration: Double
        
        fileprivate init(userInfo: [AnyHashable: Any]?) {
            self.frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
            self.animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero
        }
    }
}

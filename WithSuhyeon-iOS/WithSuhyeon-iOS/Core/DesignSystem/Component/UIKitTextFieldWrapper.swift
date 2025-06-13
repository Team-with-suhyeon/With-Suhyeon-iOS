//
//  UIKitTextFieldWrapper.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/11/25.
//

import SwiftUI

private final class BoxView: UIView {
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric,
              height: UIView.noIntrinsicMetric)
    }
}

struct UIKitTextFieldWrapper: UIViewRepresentable {
    let text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isNumber: Bool
    let maxLength: Int
    let onTextChange: (String) -> Void
    let onFocusChange: (Bool) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let box = BoxView()
        let tf  = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = placeholder
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray400
            ]
        )
        tf.font = .body03R
        tf.keyboardType = keyboardType
        tf.delegate = context.coordinator
        tf.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textChanged(_:)),
            for: .editingChanged
        )
        
        box.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            tf.trailingAnchor.constraint(equalTo: box.trailingAnchor),
            tf.topAnchor.constraint(equalTo: box.topAnchor),
            tf.bottomAnchor.constraint(equalTo: box.bottomAnchor)
        ])
        
        context.coordinator.textField = tf
        return box
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let tf = context.coordinator.textField, tf.text != text else { return }
        tf.text = text
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UIKitTextFieldWrapper
        weak var textField: UITextField?
        
        init(parent: UIKitTextFieldWrapper) { self.parent = parent }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.onFocusChange(true)
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onFocusChange(false)
        }
        
        @objc func textChanged(_ sender: UITextField) {
            var value = sender.text ?? ""
            
            parent.onTextChange(value)
        }
    }
}

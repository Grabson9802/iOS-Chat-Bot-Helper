//
//  ChatGPTView.swift
//  iOSChatBotHelper
//
//  Created by Krystian Grabowy on 09/01/2024.
//

import UIKit

protocol ChatGPTViewDelegate: AnyObject {
    func userDidEnterInput(_ input: String)
}

class ChatGPTView: UIView, UITextFieldDelegate {
    
    let responseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "testing"
        label.textColor = .label
        return label
    }()
    
    let userInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your message..."
        return textField
    }()
    
    weak var delegate: ChatGPTViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        
        addSubview(responseLabel)
        addSubview(userInputTextField)
        
        configureConstraints()
        
        userInputTextField.delegate = self
    }
    
    private func configureConstraints() {
        responseLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        responseLabel.bottomAnchor.constraint(lessThanOrEqualTo: userInputTextField.topAnchor).isActive = true
        responseLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        responseLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        userInputTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        userInputTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        userInputTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let userInput = textField.text, !userInput.isEmpty {
            delegate?.userDidEnterInput(userInput)
            textField.text = nil
        }
        textField.resignFirstResponder()
        return true
    }
}

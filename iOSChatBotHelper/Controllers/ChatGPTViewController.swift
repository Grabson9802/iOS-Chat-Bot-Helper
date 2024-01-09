//
//  ViewController.swift
//  iOSChatBotHelper
//
//  Created by Krystian Grabowy on 09/01/2024.
//

import UIKit
import OpenAISwift

class ChatGPTViewController: UIViewController, ChatGPTViewDelegate {
    
    private var chatGPTModel: ChatGPTResponse?
    private var chatGPTView: ChatGPTView!
    private var client: OpenAISwift?
    
    init(model: ChatGPTResponse) {
        self.chatGPTModel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        chatGPTView = ChatGPTView()
        chatGPTView.delegate = self
        view = chatGPTView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatGPTViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatGPTViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func userDidEnterInput(_ input: String) {
        client = OpenAISwift(config: .makeDefaultOpenAI(apiKey: "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"))
        
        client?.sendCompletion(with: input, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                self.chatGPTModel = ChatGPTResponse(text: output)
                DispatchQueue.main.async {
                    self.updateView()
                }
            case .failure:
                break
            }
        })
    }
    
    func updateView() {
        chatGPTView.responseLabel.text = chatGPTModel?.text
    }
}

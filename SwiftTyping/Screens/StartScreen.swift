//
//  StartScreen.swift
//  SwiftTyping
//
//  Created by Zach Eriksen on 12/12/20.
//

import UIKit
import SwiftUIKit
import Fake

class StartScreen: UIViewController {
    
    deinit {
        print("deinit: StartScreen")
    }
    
    private var timeLimit: UInt = 0
    private var difficulty: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.configure(controller: navigationController)
            .set(title: "SwiftTyping")
        
        view.background(color: .systemBackground)
            .embed {
                SafeAreaView {
                    VStack(distribution: .fillEqually) {
                        [
                            Spacer(),
                            
                            VStack(withSpacing: 16) {
                                [
                                    Label("Select your time limit and difficulty"),
                                    
                                    HStack(withSpacing: 8) {
                                        [
                                            Label("Seconds").setHorizontal(huggingPriority: .required),
                                            
                                            Field(value: "", placeholder: "# of Seconds", keyboardType: .numberPad)
                                                .inputHandler { [weak self] value in
                                                    guard let timeLimit = UInt(value) else {
                                                        return
                                                    }
                                                    
                                                    self?.timeLimit = timeLimit
                                                }
                                                .configure { $0.borderStyle = .roundedRect },
                                        ]
                                    },
                                    
                                    HStack(withSpacing: 8) {
                                        [
                                            Label("Words").setHorizontal(huggingPriority: .required),
                                            
                                            Field(value: "", placeholder: "# of Words", keyboardType: .numberPad)
                                                .inputHandler { [weak self] value in
                                                    guard let difficulty = UInt(value) else {
                                                        return
                                                    }
                                                    
                                                    self?.difficulty = difficulty
                                                }
                                                .configure { $0.borderStyle = .roundedRect },
                                        ]
                                    },
                                ]
                            },
                            
                            Spacer(),
                            
                            Button("Start!") { [weak self] in
                                self?.start()
                            }
                        ]
                    }
                }
            }
            .gesture {
                UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func start() {
        guard timeLimit > 0,
              difficulty > 0 else {
            return
        }
        
        Navigate.shared.go(GameScreen(timeLimit: timeLimit, difficulty: difficulty), style: .push)
    }
}

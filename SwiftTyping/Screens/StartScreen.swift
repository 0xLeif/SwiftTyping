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
                VScroll {
                    VStack(withSpacing: 16, padding: 32) {
                        [
                            Label.title1("Select your time limit and difficulty")
                                .number(ofLines: 3),
                            
                            HStack(withSpacing: 8, distribution: .fillProportionally) {
                                [
                                    Label.callout("Seconds"),
                                    
                                    Field(value: "\(timeLimit)", placeholder: "# of Seconds", keyboardType: .numberPad)
                                        .inputHandler { [weak self] value in
                                            guard let timeLimit = UInt(value) else {
                                                return
                                            }
                                            
                                            self?.timeLimit = timeLimit
                                        }
                                        .configure {
                                            $0.borderStyle = .roundedRect
                                            $0.autocapitalizationType = .none
                                            $0.autocorrectionType = .no
                                        },
                                ]
                            }
                            .frame(height: 60),
                            
                            HStack(withSpacing: 8, distribution: .fillProportionally) {
                                [
                                    Label.callout("Words"),
                                    
                                    Field(value: "\(difficulty)", placeholder: "# of Words", keyboardType: .numberPad)
                                        .inputHandler { [weak self] value in
                                            guard let difficulty = UInt(value) else {
                                                return
                                            }
                                            
                                            self?.difficulty = difficulty
                                        }
                                        
                                        .configure {
                                            $0.borderStyle = .roundedRect
                                            $0.autocapitalizationType = .none
                                            $0.autocorrectionType = .no
                                        },
                                ]
                            }
                            .frame(height: 60),
                            
                            Spacer(),
                            
                            Button("Start!") { [weak self] in
                                self?.start()
                            }
                            .set(titleColor: .white)
                            .frame(height: 60)
                            .layer(backgroundColor: .systemBlue)
                            .layer(cornerRadius: 8)
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
            Navigate.shared.alert(title: "Select your time limit and difficulty",
                                  message: "Good Luck!",
                                  withActions: [.dismiss],
                                  secondsToPersist: nil)
            return
        }
        
        Navigate.shared.go(GameScreen(timeLimit: timeLimit, difficulty: difficulty), style: .push)
    }
}

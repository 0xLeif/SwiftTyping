//
//  GameScreen.swift
//  SwiftTyping
//
//  Created by Zach Eriksen on 12/12/20.
//

import UIKit
import SwiftUIKit
import Fake
import EKit
import Later

class GameScreen: UIViewController {
    
    deinit {
        print("deinit: GameScreen")
        task?.cancel()
    }
    
    var timeLimit: Int
    var difficulty: Int
    
    private var word: String
    private var typed = ""
    private var correct = 0
    
    private var task: ScheduledTask<Void>?
    
    private var gameView: UIView = UIView()
    
    private var resultsView: UIView {
        UIView(backgroundColor: .systemBackground).center {
            Label.title1("# Correct: \(correct)")
                .number(ofLines: 0)
        }
        .navigateSet(title: "Results")
    }
    
    init(
        timeLimit: UInt,
        difficulty: UInt
    ) {
        self.timeLimit = Int(timeLimit)
        self.difficulty = Int(difficulty)
        
        self.word = Fake.Word.Random.sentence(words: self.difficulty)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        defer {
            draw()
        }
        
        super.viewDidLoad()
        
        view.background(color: .systemBackground)
            .embed {
                gameView
            }
        
        task = Later.scheduleTask(in: .seconds(Int64(timeLimit))) { [weak self] in
            DispatchQueue.main.async {
                print("Show Results...")
                self?.showResults()
            }
        }
    }
    
    private func draw() {
        gameView.clear()
            .embed {
                SafeAreaView {
                    VStack(withSpacing: 16) {
                        [
                            VScroll {
                                Label.headline(word)
                                    .number(ofLines: 0)
                            }
                            .frame(height: 120)
                            .padding(),
                            
                            Field(value: "",
                                  placeholder: "",
                                  keyboardType: .default)
                                .inputHandler { [weak self] in
                                    self?.typed = $0
                                    self?.softCheck()
                                }
                                .configure { field in
                                    field.borderStyle = .roundedRect
                                    field.becomeFirstResponder()
                                },
                            
                            Spacer(),
                            
                            Button("Done") { [weak self] in
                                self?.check()
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
    
    private func softCheck() {
        guard word == typed else {
            return
        }
        
        check()
    }
    
    private func check() {
        defer {
            Navigate.shared.set(title: "Correct: \(correct)")
            word = Fake.Word.Random.sentence(words: difficulty)
            typed = ""
            draw()
        }
        
        guard word == typed else {
            Navigate.shared.toast(style: .error,
                                  pinToTop: true,
                                  secondsToPersist: 1,
                                  padding: 32) {
                Label.title1("Wrong!")
            }
            return
        }
        
        correct += 1
    }
    
    private func showResults() {
        gameView.clear()
            .embed {
            resultsView
        }
    }
}

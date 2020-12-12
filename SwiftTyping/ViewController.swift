//
//  ViewController.swift
//  SwiftTyping
//
//  Created by Zach Eriksen on 12/12/20.
//

import UIKit
import SwiftUIKit
import Fake

class ViewController: UIViewController {
    var word = Fake.Word.Random.sentence(words: 5)
    var typed = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.configure(controller: navigationController)
     
        
        draw()
    }
    
    private func draw() {
        view.clear().embed(withPadding: 32) {
            VStack {
                [
                
                    Label(word),
                    
                    Field(value: "", placeholder: "...", keyboardType: .default)
                        .inputHandler { [weak self] in self?.typed = $0 },
                    
                    Button("Done") { [weak self] in
                        self?.check()
                    }
                    
                ]
            }
        }
    }
    
    private func check() {
        defer {
            word = Fake.Word.Random.sentence(words: 5)
            typed = ""
            draw()
        }
        
        guard word == typed else {
            Navigate.shared.alert(title: "Wrong!", message: "", secondsToPersist: 3)
            return
        }
        
        Navigate.shared.alert(title: "Correct!", message: "", secondsToPersist: 3)
    }
}


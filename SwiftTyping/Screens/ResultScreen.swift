//
//  ResultScreen.swift
//  SwiftTyping
//
//  Created by Zach Eriksen on 12/12/20.
//

import UIKit
import SwiftUIKit

class ResultScreen: UIViewController {
    
    deinit {
        print("deinit: ResultScreen")
    }
    
    var correct: Int
    
    init(correct: Int) {
        self.correct = correct
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.background(color: .systemBackground).center {
            Label("Congratz!\n# Correct: \(correct)").number(ofLines: 2)
        }
        .navigateSetRight(barButton: BarButton {
            Button("Restart") {
                Navigate.shared.back(toRoot: true)
            }
        })
    }
}

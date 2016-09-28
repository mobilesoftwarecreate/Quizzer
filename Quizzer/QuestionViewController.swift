//
//  QuestionViewController.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.29.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class QuestionViewController: UIViewController {

	var questionModel: QuestionModel? {
		didSet {
			let answersCount = questionModel?.answers.count
			
			question.text = questionModel?.question
			question1.text = questionModel?.answers[0].answer
			if answersCount > 1 {
				question2.text = questionModel?.answers[1].answer
			} else {
				questionSwitch2.isHidden = true
				question2.isHidden = true
			}
			
			if answersCount > 2 {
				question3.text = questionModel?.answers[2].answer
			} else {
				questionSwitch3.isHidden = true
				question3.isHidden = true
			}
			
			if answersCount > 3 {
				question4.text = questionModel?.answers[3].answer
			} else {
				questionSwicth4.isHidden = true
				question4.isHidden = true
			}
			
			
			questionSwitch1.isOn = false
			questionSwitch2.isOn = false
			questionSwitch3.isOn = false
			questionSwicth4.isOn = false
			
			btnNext.isEnabled = false
		}
	}
	
	var answerIsCorrect: Bool {
		get {
			if questionSwitch1.isOn && questionModel!.answers[0].isCorrect {
				return true
			} else if questionSwitch2.isOn && questionModel!.answers[1].isCorrect {
				return true
			} else if questionSwitch3.isOn && questionModel!.answers[2].isCorrect {
				return true
			} else if questionSwicth4.isOn && questionModel!.answers[3].isCorrect {
				return true
			} else  {
				return false
			}
		}
	}
	
	@IBOutlet weak var quizTitle: UILabel!
	@IBOutlet weak var quizProgress: UIProgressView!
	@IBOutlet weak var question: UILabel!
	var btnNext: UIBarButtonItem!
	
	@IBOutlet weak var questionSwitch1: UISwitch!
	@IBOutlet weak var questionSwitch2: UISwitch!
	@IBOutlet weak var questionSwitch3: UISwitch!
	@IBOutlet weak var questionSwicth4: UISwitch!
	
	
	@IBOutlet weak var question1: UILabel!
	@IBOutlet weak var question2: UILabel!
	@IBOutlet weak var question3: UILabel!
	@IBOutlet weak var question4: UILabel!
	
    
	@IBAction func checkAnswer(_ sender: UISwitch) {
		let newState = sender.isOn
		
		questionSwitch1.isOn = false
		questionSwitch2.isOn = false
		questionSwitch3.isOn = false
		questionSwicth4.isOn = false
		
		sender.isOn = newState
		btnNext.isEnabled = newState
	}
}

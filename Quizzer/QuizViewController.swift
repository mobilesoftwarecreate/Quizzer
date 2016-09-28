 //
//  QuizViewController.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.29.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: UIViewController, QuizQuestionsProtocol {

	let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
	
	@IBOutlet weak var questionView: UIView!
	@IBOutlet weak var quizEndView: UIView!
	@IBOutlet weak var btnNext: UIBarButtonItem!
	
	var quizInfoModel: QuizInfoModel?
	
	var questionViewController: QuestionViewController?
	var quizEndViewController: QuizEndViewController?
	var questionNumber: Int16 = 0 {
		didSet {
			questionViewController!.quizProgress.progress = Float(questionNumber) / Float(allQuestionNumber)
		}
	}
	var allQuestionNumber: Int16 = 0 {
		didSet {
			questionViewController!.quizProgress.progress = Float(questionNumber) / Float(allQuestionNumber)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		getQuizState()
		
		let quizQuestions = QuizQuestions(delegate: self)
		quizQuestions.getAllAnswers(quizInfoModel!)

		questionView.alpha = 0
		quizEndView.alpha  = 0
    }
	
	fileprivate func getQuizState() {
		let entityDescription = NSEntityDescription.entity(forEntityName: "QuizState", in: managedObjectContext)
		let predicate = NSPredicate(format: "(id = %ld)", quizInfoModel!.id)
		
		let fetchRequest = NSFetchRequest<QuizState>()
		fetchRequest.entity = entityDescription
		fetchRequest.predicate = predicate
		
		do {
			let result = try self.managedObjectContext.fetch(fetchRequest)
			if (result.count > 0) {
				quizInfoModel!.quizState = result[0]
				questionNumber = quizInfoModel!.quizState!.lastDidQuestionNumber
			}
			else {
				quizInfoModel!.quizState = QuizState(entity: entityDescription!, insertInto: managedObjectContext)
				quizInfoModel!.quizState!.id = quizInfoModel!.id
				quizInfoModel!.quizState!.lastDidQuestionNumber = 0
				quizInfoModel!.quizState!.lastResult = 0
				
				do {
					try quizInfoModel!.quizState!.managedObjectContext!.save()
				} catch {
					print(error)
				}
			}
			
			
		} catch {
			let fetchError = error as NSError
			print(fetchError)
		}
	}
	
	func didGetQuizQuestions(_ quiz: QuizInfoModel) {
		quizInfoModel = quiz
		questionViewController!.quizTitle.text = quizInfoModel!.title
		allQuestionNumber = Int16(quizInfoModel!.questions.count)
		
		goToNextQuestion()
	}
	

	@IBAction func goToNextQuestion(_ sender: AnyObject) {
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
			self.questionView.alpha = 0
		})
		
		checkAnswer()
		writeProgress()
		goToNextQuestion()
	}
	
	fileprivate func goToNextQuestion() {
		questionNumber = questionNumber + 1
		if questionNumber < allQuestionNumber {
			questionViewController!.questionModel = quizInfoModel!.questions[Int(questionNumber)]
			
			
			
			UIView.animate(withDuration: 1, animations: { () -> Void in
				self.questionView.alpha = 1
			})
		} else {
			endQuiz()
		}
	}
	
	fileprivate func checkAnswer() {
		quizInfoModel!.questions[Int(questionNumber)].answerWasCorrect = questionViewController!.answerIsCorrect
		if questionViewController!.answerIsCorrect == true {
			quizInfoModel!.quizState!.lastResult = quizInfoModel!.quizState!.lastResult + 1
		}
	}
	
	fileprivate func writeProgress() {
		quizInfoModel!.quizState!.lastDidQuestionNumber = questionNumber
		//quizInfoModel!.quizState!.lastResult = quizInfoModel!.correctAnswers
		
		do {
			try quizInfoModel!.quizState!.managedObjectContext!.save()
		} catch {
			print(error)
		}
	}
	
	fileprivate func endQuiz() {
		self.navigationItem.rightBarButtonItem = nil
		
		let result = Int(Float(quizInfoModel!.quizState!.lastResult) / Float(allQuestionNumber) * 100)
		
		for rate in quizInfoModel!.rates {
			if rate.from < result && rate.to >= result {
				quizEndViewController?.quizResult.text = rate.result
				break
			}
		}
		
		UIView.animate(withDuration: 1, animations: { () -> Void in
			self.quizEndView.alpha = 1
		})
	}

	
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "questionsSegue" {
			questionViewController = (segue.destination as! QuestionViewController)
			questionViewController?.btnNext = self.btnNext
		}
		if segue.identifier == "quizEndSegue" {
			quizEndViewController = (segue.destination as! QuizEndViewController)
		}
    }
}

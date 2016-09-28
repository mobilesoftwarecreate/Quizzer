//
//  QuizQuestions.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.30.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol QuizQuestionsProtocol {
	func didGetQuizQuestions(_ quiz: QuizInfoModel)
}

class QuizQuestions {
	var delegate: QuizQuestionsProtocol
	
	
	init(delegate: QuizQuestionsProtocol) {
		self.delegate = delegate
	}
	
	func getAllAnswers( _ quizInfo: QuizInfoModel) { //-> QuizInfoModel {
		
		let url = URL(string: "http://quiz.o2.pl/api/v1/quiz/\(quizInfo.id)/0")!
		
		Alamofire.request(url).validate().responseJSON {
			response in
			switch response.result {
			case .success:
				
				if let value = response.result.value {
					let json = JSON(value)
					self.parseQuiz(quizInfo, json: json)
					self.delegate.didGetQuizQuestions(quizInfo)
					
					//return quizInfo
				}
				
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	fileprivate func parseQuiz( _ quizInfo: QuizInfoModel, json: JSON) {
		//let json = JSON(value)
		//var quizInfoList = [QuizInfoModel]()
		
		for quizRatesJson in json.dictionaryValue["rates"]!.array! {
			let quizRate = self.parseQuizRates(quizRatesJson)
			quizInfo.rates.append(quizRate)
		}
		
		for quizQuestionJson in json.dictionaryValue["questions"]!.array! {
			let quizQuestion = self.parseQuizQuestions(quizQuestionJson)
			quizInfo.questions.append(quizQuestion)
		}
		
		//return quizInfo
	}
	
	fileprivate func parseQuizRates(_ quizRatesJson: JSON) -> RatesModel {
		let from = quizRatesJson["from"].int!
		let to = quizRatesJson["to"].int!
		let result = quizRatesJson["content"].string!
		let quizRate = RatesModel(from: from, to: to, result: result)
		
		return quizRate
	}
	
	fileprivate func parseQuizQuestions(_ quizQuestion: JSON) -> QuestionModel {
		let text = quizQuestion["text"].string!
		let order = quizQuestion["order"].int!
		var answers = [AnswerModel]()
		
		for answersJson in quizQuestion["answers"].arrayValue {
			let answer = parseAnswers(answersJson)
			answers.append(answer)
		}
		
		let question = QuestionModel(order: order, question: text, answers: answers)
		
		return question
	}
	
	fileprivate func parseAnswers(_ answersJson: JSON) -> AnswerModel {
		let text = answersJson["text"].string ?? ""
		let isCorrect = answersJson["isCorrect"].int == 1
		
		let answer = AnswerModel(answer: text, isCorrect: isCorrect)
		return answer
	}
}

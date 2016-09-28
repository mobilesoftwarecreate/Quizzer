//
//  QuestionModel.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.30.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import Foundation

struct QuestionModel {
	var order: Int
	var question: String
	var answers: [AnswerModel]
	var answerWasCorrect: Bool
	
	init(order: Int, question: String, answers: [AnswerModel]) {
		self.order = order
		self.question = question
		self.answers = answers
		self.answerWasCorrect = false
	}
}

struct AnswerModel {
	var answer: String
	var isCorrect: Bool
	
	init(answer: String, isCorrect: Bool) {
		self.answer = answer
		self.isCorrect = isCorrect
	}
}

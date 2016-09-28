//
//  QuizInfoModel.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.28.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import Foundation

class QuizInfoModel {
	var id: Int64 = 0
	var title: String = ""
	var imageUrl: String = ""
	
	var quizState: QuizState?
	
	var questions = [QuestionModel]()
	var rates = [RatesModel]()
}

struct RatesModel {
	var from: Int
	var to: Int
	var result: String
	
	init(from: Int, to: Int, result: String) {
		self.from = from
		self.to = to
		self.result = result
	}
}



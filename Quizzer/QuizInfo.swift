//
//  QuizInfo.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.28.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData

protocol QuizInfoProtocol {
	func didGetQuizList(_ quizList: [QuizInfoModel])
}

class QuizInfo {
	var delegate: QuizInfoProtocol
	let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
	
	
	init(delegate: QuizInfoProtocol) {
		self.delegate = delegate
	}
	
	func getAllQuizes() {
		Alamofire.request("http://quiz.o2.pl/api/v1/quizzes/0/100").validate().responseJSON {
			response in
			switch response.result {
			case .success:
				
				if let value = response.result.value {
				
					let json = JSON(value)
					var quizInfoList = [QuizInfoModel]()
					
					for quizInfoJson in json.dictionaryValue["items"]!.array! {
						let quizInfo = self.parseQuiz(quizInfoJson)
						
						quizInfoList.append(quizInfo)
					}
					
					self.delegate.didGetQuizList(quizInfoList)
				}
				
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	fileprivate func parseQuiz(_ quizInfoJson: JSON) -> QuizInfoModel {
		var quizInfo = QuizInfoModel()
		quizInfo.id = quizInfoJson["id"].int64Value
		quizInfo.title = quizInfoJson["title"].stringValue
		quizInfo.imageUrl = quizInfoJson["mainPhoto"]["url"].stringValue
		
		fillInfoAboutProgress(&quizInfo)
		
		return quizInfo
	}
	
	fileprivate func fillInfoAboutProgress( _ quizInfo: inout QuizInfoModel) {
		let entityDescription = NSEntityDescription.entity(forEntityName: "QuizState", in: managedObjectContext)
		let predicate = NSPredicate(format: "(id = %ld)", quizInfo.id)
		
		let fetchRequest = NSFetchRequest<QuizState>()
		fetchRequest.entity = entityDescription
		fetchRequest.predicate = predicate
		
		do {
			let result = try self.managedObjectContext.fetch(fetchRequest)
			if (result.count > 0) {
				quizInfo.quizState = result[0] 
			}
		} catch {
			let fetchError = error as NSError
			print(fetchError)
		}
	}
}

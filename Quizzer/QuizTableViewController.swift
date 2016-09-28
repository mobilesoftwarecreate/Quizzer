//
//  QuizTableViewController.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.28.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController, QuizInfoProtocol {

	var quizList = [QuizInfoModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let quizInfo = QuizInfo(delegate: self)
		quizInfo.getAllQuizes()
    }

	func didGetQuizList(_ quizList: [QuizInfoModel]) {
		self.quizList = quizList
		self.tableView.reloadData()
	}
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizInfo", for: indexPath) as! QuizInfoTableViewCell

		cell.quizInfoModel = quizList[(indexPath as NSIndexPath).item]

        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}

	
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "quizOpen" {
			let destination = segue.destination as! QuizViewController 
				let indexPath = tableView.indexPathForSelectedRow!
				let quiz = quizList[(indexPath as NSIndexPath).item]
				destination.quizInfoModel = quiz
			
		}
    }
}

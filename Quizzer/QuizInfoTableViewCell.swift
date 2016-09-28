//
//  QuizInfoTableViewCell.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.07.28.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class QuizInfoTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var lastResultLabel: UILabel!
	@IBOutlet weak var lastRunPercentage: UILabel!
	@IBOutlet weak var quizImage: UIImageView!
	
	
	var quizInfoModel: QuizInfoModel = QuizInfoModel() {
		didSet {
			titleLabel.text = quizInfoModel.title
			let URL = Foundation.URL(string: quizInfoModel.imageUrl)!
			quizImage.image = nil
			quizImage.af_setImage(withURL: URL)
			
			if let quizState = quizInfoModel.quizState {
				lastRunPercentage.text = String(format: "%d%%", Int(Float(quizState.lastDidQuestionNumber) / Float(10) * 100))
				lastResultLabel.text = String(format: "%d pkt", quizState.lastResult)
			}else {
				lastRunPercentage.text = "0%"
				lastResultLabel.text = "0 pkt"
			}
		}
	}
}

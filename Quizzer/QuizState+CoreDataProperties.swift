//
//  QuizState+CoreDataProperties.swift
//  Quizzer
//
//  Created by Michał Szafrański on 2016.08.18.
//  Copyright © 2016 e-szafranski.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QuizState {

    @NSManaged var id: Int64
    @NSManaged var lastDidQuestionNumber: Int16
    @NSManaged var lastResult: Int16

}

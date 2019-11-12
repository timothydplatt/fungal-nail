//
//  Question.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 12/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import Foundation

class Question {

    let answer : Bool
    let questionText : String

    init(text : String, correctAnswer : Bool) {
        questionText = text
        answer = correctAnswer
    }

}

//
//  QuestionBank.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 12/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import Foundation

class QuestionBank {

    var list = [Question]()

    init() {
        // Creating a quiz item and appending it to the list
        let item = Question(text: "Toenail fungus is harmless.", correctAnswer: false)

        // Add the Question to the list of questions
        list.append(item)

        // skipping one step and just creating the quiz item inside the append function
        list.append(Question(text: "You can’t get it if you wear nail polish", correctAnswer: false))

        list.append(Question(text: "Over-the-counter products alone will cure it.", correctAnswer: false))

        list.append(Question(text: "You can catch it from other people.", correctAnswer: true))

        list.append(Question(text: "Shower shoes are the only weapon against toenail fungus.", correctAnswer: false))

        list.append(Question(text: "Yellow nails are often the first sign.", correctAnswer: true))

        list.append(Question(text: "Your doctor will give you antibiotics.", correctAnswer: false))

        list.append(Question(text: "Young people get toe fungus less often.", correctAnswer: true))

        list.append(Question(text: "Fingernail fungus is just as common.", correctAnswer: false))

        //TODO: - Update below questions
        list.append(Question(text: "Buzz Aldrin\'s mother\'s maiden name was \"Moon\".", correctAnswer: true))

        list.append(Question(text: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", correctAnswer: false))

        list.append(Question(text: "No piece of square dry paper can be folded in half more than 7 times.", correctAnswer: false))

        list.append(Question(text: "Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.", correctAnswer: true))
    }

}



//
//  QuizVC.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 12/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuizVC: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //This action gets called when either the true or false button is pressed.
    @objc @IBAction func answerPressed(_ sender: AnyObject) {
        
        if sender.tag == 1 {
            pickedAnswer = true
        }
            
        else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer()
        questionNumber = questionNumber + 1
        updateUI()
    }
    
    // This method will update all the views on screen (progress bar, score label, etc)
    func updateUI() {
        
        //        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber)
        
        
        self.progressBarWidth.constant = (self.view.frame.size.width / 13) * CGFloat(self.questionNumber)
        
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        progressLabel.text = String(questionNumber) + "/13"
        
        scoreLabel.text = "Score: " + String(score)
        
        nextQuestion()
    }
    
    //This method will update the question text and check if we reached the end.
    func nextQuestion() {
        
        if questionNumber <= 12 {
            questionLabel.text = allQuestions.list[questionNumber].questionText
        }
        else {
            let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { UIAlertAction in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    //This method will check if the user has got the right answer.
    func checkAnswer() {
        
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if correctAnswer == pickedAnswer {
            
            SVProgressHUD.showSuccess(withStatus: "Success")
            SVProgressHUD.dismiss(withDelay: 1.0)
            score = score + 1
        }
        else {
            
            SVProgressHUD.showError(withStatus: "Wrong!")
        }
    }
    
    //This method will wipe the board clean, so that users can retake the quiz.
    func startOver() {
        
        questionNumber = 0
        score = 0
        
        updateUI()
        
    }
    
}

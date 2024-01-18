//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
   
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimes = ["Soft":300 , "Medium":420 , "Hard":720 ]
    
    var timer = Timer()
    var isTimerRunnning = false
    var secondsSetting = 300
    var seconds = 0
    var isTimerRunning = false
    var resumeTapped = false
    var percentageProgress = 0.0
    var player: AVAudioPlayer!

//Time selection
   @IBAction func hardnessSelected(_ sender: UIButton) {
       if isTimerRunning == false && resumeTapped == false{
           let hardness = sender.currentTitle!
           seconds = 0
           secondsSetting = eggTimes[hardness]!
           timerLabel.text = "\(seconds)"
           progressBar.progress = 0.0
        }
    }

//Start Counting
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            seconds = 0
            runTimer()
            self.startButton.isEnabled = false
        }
    }
//Pause-Resume
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            sender.setTitle("Resume", for: .normal)
        }else{
            if isTimerRunning == false{
                runTimer()
            }
            self.resumeTapped = false
            sender.setTitle("Pause", for: .normal)
        }
    }
//Reset count
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        isTimerRunning = false
        seconds = 0
        timerLabel.text = "\(seconds)"
        progressBar.progress = 0.0
        pauseButton.isEnabled = false
        pauseButton.alpha = 0.5
        startButton.isEnabled = true
        resumeTapped = false
        pauseButton.setTitle("Pause", for: .normal)
    }
//Run the Timer
    func runTimer() {
        pauseButton.isEnabled = true
        pauseButton.alpha = 1
        if isTimerRunning == false {
                isTimerRunning = true
                timer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: (#selector(ViewController.updateTimer)),
                    userInfo: nil,
                    repeats: true)
            }
        }
//Increment count
    @objc func updateTimer(){
        if seconds < secondsSetting {
            seconds += 1
            timerLabel.text = "\(seconds)"
            percentageProgress = Double(Float(seconds)/Float(secondsSetting))
            progressBar.progress = Float(percentageProgress)
        } else{
            timer.invalidate()
            isTimerRunning = false
            pauseButton.isEnabled = false
            pauseButton.alpha = 0.5
            startButton.isEnabled = true
            timerLabel.text = "DONE!"
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
        
    }
//App startup
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
        pauseButton.titleLabel!.font = UIFont(name: "System Font Regular", size: 28)
        pauseButton.alpha = 1
        progressBar.progress = 0.0
    }
}

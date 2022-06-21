//
//  ViewController.swift
//  Speech Test
//
//  Created by Shubham Kamdi on 6/20/22.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    var audioEngine : AVAudioEngine? = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        SFSpeechRecognizer.requestAuthorization {
          [unowned self] (authStatus) in
          switch authStatus {
          case .authorized: break
              
          case .denied:
            print("Speech recognition authorization denied")
              break
          case .restricted:
            print("Not available on this device")
              break
          case .notDetermined:
            print("Not determined")
              break
          default: break
          }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
      
    }

    @IBAction func startSppech() {
        guard let node = audioEngine?.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: {
            buffer, a  in
            self.request.append(buffer)
        })
        audioEngine?.prepare()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,mode: .measurement,options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioEngine?.start()
        } catch {
            return print(error)
        }
        guard let myRecogniser = SFSpeechRecognizer() else { return }
        if !myRecogniser.isAvailable {
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.dataLabel.text = result.bestTranscription.formattedString
            } else if let error = error {
                print(error)
            }
        })
    }
    
}


//
//  TrackView.swift
//  Tinder of Music
//
//  Created by Marc Gelfo on 10/15/17.
//  Copyright © 2017 Music Star Games. All rights reserved.
//

import UIKit
import AVFoundation

class TrackView: UIView {
    var trackPlayer: AVAudioPlayer?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var waveView : UIView!
    var audioTrackURL : URL?
    

    func loadURLtoAudio(withURL: URL) {
        let path = Bundle.main.path(forResource: "example.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
    }
    
    func playheadLocation() {
        
    }
    
    func recordToAudio() {
        
    }
    
    func playAudio() {

        
        do {
            trackPlayer = try AVAudioPlayer(contentsOf: audioTrackURL!)
            trackPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    func pausePlayback() {
        
    }
    
    func archive() {
        
    }
}

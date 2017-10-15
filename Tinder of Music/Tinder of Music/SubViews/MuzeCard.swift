//
//  MuzeCard.swift
//  Tinder of Music
//
//  Created by Marc Gelfo on 10/15/17.
//  Copyright © 2017 Music Star Games. All rights reserved.
//

import UIKit
import AVFoundation

class MuzeCard: UIView, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var cardID : String = "this should be unique"
    var cardDate: Date = Date(timeIntervalSinceNow: 0)
    var backingMusicURL: URL?
    var recordingURL: URL?
    var recordingFilePath: String = ""
    var mixFilePath : String = ""
    var mixedAudioURL: URL?
    
    var cardTitle : String = "This is the title of the card like Slow Rock 1"
    
    var audioPlayer : AVAudioPlayer!
    var audioRecorder : AVAudioRecorder!
    var isPlaying : Bool = false
    
    func initializeURLS(withBackingMusic: URL) {
        
        backingMusicURL = withBackingMusic
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        
        let timeUnique : TimeInterval = Date.timeIntervalSinceReferenceDate
        
        let recFile = "User Recording \(timeUnique).caf"
        let mixFile = "Mix \(timeUnique).caf"
        
        let filePath = path.stringByAppendingPathComponent(path: recFile) as String
        let mixPath = path.stringByAppendingPathComponent(path: mixFile) as String
        
        
        recordingFilePath = filePath
        mixFilePath = mixPath

    }
    
    func pausePlayback()
    {
        
    }
    
    func playBackingTrack()
    {
        playAudio()
    }
    
    func playAudio()
    {
        
        let dispatchQueue = DispatchQueue.global(qos: .default)
        dispatchQueue.async {
            
            //if let data = NSData(contentsOfFile: self.audioFilePath())
            if let data = NSData(contentsOfFile: self.audioFilePath())
            {
                do{
                    self.audioPlayer = try AVAudioPlayer(data: data as Data)
                    self.audioPlayer.delegate = self
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                    self.isPlaying = true
                }
                catch{
                    print("\(error)")
                }
            }
        }
    }
    
    func playAudioMix() {
        // mix audio
        // identify URLs for 2 current audios
        
        // send them to the mixer & play function
        
        // play it
    }
    
    func startRecording() {
        
        playAudio()
        let session = AVAudioSession.sharedInstance()
        
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            session.requestRecordPermission({ (allowed : Bool) -> Void in
                
                if allowed {
                    self.startRecording_safe()
                }
                else{
                    print("We don't have request permission for recording.")
                }
            })
        }
        catch{
            print("\(error)")
        }
    }
    
    func stopAllAudio() {
        if let player = self.audioPlayer{
            player.stop()
            isPlaying = false
        }
        
        if let record = self.audioRecorder{
            
            record.stop()
            
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setActive(false)
            }
            catch{
                print("\(error)")
            }
        }
    }
    
    
    func startRecording_safe(){
        
        
        
        do{
            
            let fileURL = NSURL(string: self.audioFilePath())!
            self.audioRecorder = try AVAudioRecorder(url: fileURL as URL, settings: self.audioRecorderSettings() as! [String : AnyObject])
            
            if let recorder = self.audioRecorder{
                recorder.delegate = self
                
                if recorder.record() && recorder.prepareToRecord(){
                    print("Audio recording started successfully")
                }
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    func audioFilePath() -> String{
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let filePath = path.stringByAppendingPathComponent(path: "30sec440H.mp3") as String
        
        return filePath
    }
    
    func audioRecorderSettings() -> NSDictionary{
        
        let settings : NSDictionary = [AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)), AVSampleRateKey : NSNumber(value: Float(16000.0)), AVNumberOfChannelsKey : NSNumber(value: 1), AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
        
        return settings as NSDictionary
    }
    
    //MARK: AVAudioPlayerDelegate methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag == true{
            print("Player stops playing successfully")
        }
        else{
            print("Player interrupted")
        }
        
        
    }
    
    //MARK: AVAudioRecorderDelegate methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag == true{
            print("Recording stops successfully")
        }
        else{
            print("Stopping recording failed")
        }
    }
    
    func mixAudioSignals(audio1 : URL, audio2 :URL ) {
        
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
        let compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        
        let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("resultmerge.m4a")! as URL
        
        let url1 :URL = audio1
        let url2 :URL = audio2
        
        let avAsset1 = AVURLAsset(url: url1, options: nil)
        let avAsset2 = AVURLAsset(url: url2, options: nil)
        
        var tracks1 = avAsset1.tracks(withMediaType: AVMediaType.audio)
        var tracks2 = avAsset2.tracks(withMediaType: AVMediaType.audio)
        
        let assetTrack1:AVAssetTrack = tracks1[0]
        let assetTrack2:AVAssetTrack = tracks2[0]
        
        let duration1: CMTime = assetTrack1.timeRange.duration
        let duration2: CMTime = assetTrack2.timeRange.duration
        
        let timeRange1 = CMTimeRangeMake(kCMTimeZero, duration1)
        let timeRange2 = CMTimeRangeMake(kCMTimeZero, duration2)
        
        do
        {
            try compositionAudioTrack1.insertTimeRange(timeRange1, of: assetTrack1, at: kCMTimeZero)
            try compositionAudioTrack2.insertTimeRange(timeRange2, of: assetTrack2, at: kCMTimeZero)
        }
        catch
        {
            print(error)
        }
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = fileDestinationUrl
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: assetExport?.error))")
                    break
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: assetExport?.error))")
                    break
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: assetExport?.error))")
                    break
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: assetExport?.error))")
                    break
                    
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: assetExport?.error))")
                    break
                    
                default:
                    print("Audio Mix complete no errors!")
                }
                
                // PUT THE CODE TO PLAY AUDIO FILE NOW
                /*
                 do
                 {
                 
                 
                 playAudio(
                 self.player = try AVAudioPlayer(contentsOf: self.fileDestinationUrl),
                 self.player?.numberOfLoops = 0
                 self.player?.prepareToPlay()
                 self.player?.volume = 1.0
                 self.player?.play()
                 self.player?.delegate=self
                 }
                 catch let error as NSError
                 {
                 print(error)
                 }*/
        })
    }
    

}

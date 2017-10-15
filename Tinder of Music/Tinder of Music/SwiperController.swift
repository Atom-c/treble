//
//  SwiperController.swift
//  Tinder of Music
//
//  Created by Marc Gelfo on 10/14/17.
//  Copyright © 2017 Music Star Games. All rights reserved.
//

import UIKit
import AVFoundation

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

class SwiperController: UIViewController {
    var audioPlayer : AVAudioPlayer!
    var audioRecorder : AVAudioRecorder!
    
    //state variables
    
    var isPlaying : Bool = false
    var isRecording: Bool = false
    var hasRecorded: Bool = false
    var hasMixed: Bool = false
    

    @IBOutlet weak var currCard: MuzeCard!
    @IBOutlet weak var swipeLabel: UILabel!

    // -- BACKING TRACK VIEW
    @IBOutlet weak var backing_lblCurrTime: UILabel!
    @IBOutlet weak var backing_lblTitle: UILabel!
    @IBOutlet weak var backing_lblFinalTime: UILabel!
    @IBOutlet weak var backing_btnPlayPause: UIButton!
    
    // -- CONTRIBUTION TRACK VIEW
    @IBOutlet weak var contribution_lblTitle: UILabel!
    @IBOutlet weak var contribution_lblStartTime: UILabel!
    @IBOutlet weak var contribution_btnRecordStop: UIButton!
    @IBOutlet weak var contribution_lblFinishTime: UILabel!
    
    
    // -- MIX TRACK VIEW
    @IBOutlet weak var mix_lblFinishTime: UILabel!
    @IBOutlet weak var mix_lblStartTime: UILabel!
    @IBOutlet weak var mix_lblTitle: UILabel!
    @IBOutlet weak var mix_btnPlayPause: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        currCard.addGestureRecognizer(gesture)
        swipeLabel.addGestureRecognizer(gesture)
        
        
    }

    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        print("DRAG EVENT")
        let labelPoint = gestureRecognizer.translation(in: view)
        currCard.center = CGPoint(x: view.bounds.width/2 + labelPoint.x, y: view.bounds.height/2 + labelPoint.y)
        
        var xFromCenter = view.bounds.width / 2 - currCard.center.x
        
        if ((xFromCenter < 10) && (xFromCenter > -10)) {
            xFromCenter = 0
        }
        
        let sliderval = -500 //rotationSlider.value
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / CGFloat(sliderval))
        
        let scale = 1.0
        var scaledAndRotated = rotation.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
 
        
        currCard.transform = scaledAndRotated
        
        if gestureRecognizer.state  == .ended {
            // swipe left
            if currCard.center.x < (view.bounds.width/2 - 100) {
                
            }
            // swipe right
            else if currCard.center.x > (view.bounds.width/2 + 100) {
                
            }
            
            //reset the label after doing a swipe
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            currCard.transform = scaledAndRotated
            currCard.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        }
//        else if gestureRecognizer.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnBackgroundPlayPause(_ sender: Any) {
        
    }
    
    @IBAction func onBtn_ContributionRecordStop(_ sender: Any) {
        
    }
    
    @IBAction func onBtnFinalMixPlayPause(_ sender: Any) {
        
    }
    
    func loadBackingTrack()
    {
        backing
    }
    
    func startRecording_safe() {
        
    }
    
    func startMix() {
        
    }
    
    func mixDone() {
        
    }
    
    
    /*
    func mixAudioStreams(audio1: NSURL, audio2:  NSURL)
    {
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())!
        let compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())!
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        self.fileDestinationUrl = documentDirectoryURL.appendingPathComponent("resultmerge.m4a")! as URL
        
        let filemanager = FileManager.default
        if (!filemanager.fileExists(atPath: self.fileDestinationUrl.path))
        {
            do
            {
                try filemanager.removeItem(at: self.fileDestinationUrl)
            }
            catch let error as NSError
            {
                NSLog("Error: \(error)")
            }
            
            if (theError == nil)
            {
                print("The music files has been Removed.")
            }
            else
            {
                print("Error")
            }
        }
        else
        {
            do
            {
                try filemanager.removeItem(at: self.fileDestinationUrl)
            }
            catch let error as NSError
            {
                NSLog("Error: \(error)")
            }
            
            if (theError == nil)
            {
                print("The music files has been Removed.")
            }
            else
            {
                print("Error")
            }
        }
        
        let url1 = audio1
        let url2 = audio2
        
        let avAsset1 = AVURLAsset(url: url1 as URL, options: nil)
        let avAsset2 = AVURLAsset(url: url2 as URL, options: nil)
        
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
                    print("failed \(assetExport?.error)")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(assetExport?.error)")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(assetExport?.error)")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(assetExport?.error)")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(assetExport?.error)")
                default:
                    print("complete")
                }
                
                do
                {
                    self.player = try AVAudioPlayer(contentsOf: self.fileDestinationUrl)
                    self.player?.numberOfLoops = 0
                    self.player?.prepareToPlay()
                    self.player?.volume = 1.0
                    self.player?.play()
                    self.player?.delegate=self
                }
                catch let error as NSError
                {
                    print(error)
                }
        })
    }
 */
}

//
//  VoiceViewController.swift
//  note
//
//  Created by ChenZuo on 2017/8/9.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var meterTimer:Timer!
    var url:URL!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : 44100.0,//声音采样率
                          AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),//编码格式
                          AVNumberOfChannelsKey: 1,//采集音轨
                          AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue)]//音频质量
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()!,
                                                settings: recordSettings)//初始化实例
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()//准备录音
            meterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(volumeChange), userInfo: nil, repeats: true)
            meterTimer.fire()
            
        } catch {
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        meterTimer.invalidate()
        //删除空白录音
        if audioRecorder.currentTime <= 0 {
            do {
                try FileManager.default.removeItem(at: url)
            } catch  {
            }
        }
    }
    
    //音量
    func volumeChange() {
        if audioRecorder.isRecording {
            audioRecorder.updateMeters()
            print(audioRecorder.peakPower(forChannel: 0))
            
            let hour = Int(audioRecorder.currentTime/(24 * 60))
            let minute = Int(audioRecorder.currentTime/60)
            let second = Int(audioRecorder.currentTime/1)
            let millisecond = Int((Float(audioRecorder.currentTime) - Float(second)) * 100)
            
            let timeString = String(format: "%02d:%02d:%02d.%02d", hour,minute,second,millisecond)
            
            timeLabel.text = timeString
        }
    }
    

    func directoryURL() -> URL? {
        //定义并构建一个url来保存音频，音频文件名为yyyyMMddHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        url = soundURL
        return soundURL
    }

    func stop() {
        //停止录音
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            audioRecorder.pause()
            print("stop!!")
        } catch {
        }
    }
    
    func start() {
        //开始录音
        
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
            }
        }
    }
    
    func play() {
        //开始播放
        if (audioRecorder.isRecording){
            startButton.isSelected = !startButton.isSelected
        }
        audioRecorder.stop()
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.play()
            print("play!!")
            
        } catch {
        }
    }
    
    func pause() {
        //暂停播放
        if (!audioRecorder.isRecording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.pause()
                
                print("pause!!")
            } catch {
            }
        }
    }
    
    @IBAction func recordingClick(_ sender: UIButton) {
        
        if sender.isSelected {
            stop()
        }else{
            start()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func playClick(_ sender: UIButton) {
        if sender.isSelected {
            pause()
        }else{
            play()
        }
        sender.isSelected = !sender.isSelected
    }
    
}

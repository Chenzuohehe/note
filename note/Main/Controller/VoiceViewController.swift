//
//  VoiceViewController.swift
//  note
//
//  Created by ChenZuo on 2017/8/9.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var playProgressView: UIProgressView!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var authorized:Bool!
    
    var meterTimer:Timer?
    var progressTimer:Timer?
    
    var url:URL!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : 44100.0,//声音采样率
                          AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),//编码格式
                          AVNumberOfChannelsKey: 1,//采集音轨
                          AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue)]//音频质量
    
    //根据时间来设置存储文件名
    func directoryURL() -> URL? {
        //定义并构建一个url来保存音频，音频文件名为yyyyMMddHHmmss.caf
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorized = false
        readyForRecorder()
        detection()
        let rightBtn = UIBarButtonItem(title: "确认添加", style: .plain, target: self, action: #selector(confrimClick))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        meterTimer?.invalidate()
        progressTimer?.invalidate()
        //删除空白录音
        if authorized {
            if audioRecorder.currentTime <= 0 {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch  {
                }
            }
        }
    }
    
    func detection() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        switch authStatus {
        case .authorized:
            print("合法")
            authorized = true
        default:
            print("否定")
            let alertController = UIAlertController(title: "提示", message: "如需使用请在 隐私->麦克风 中允许", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
                print("确认")
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    func readyForRecorder() {
        //初始化recorder
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()!,
                                                settings: recordSettings)//初始化实例
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()//准备录音
            
            meterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(meterChange), userInfo: nil, repeats: true)
            meterTimer?.fire()
            print("success")
        } catch {
        }
    }
    
    //输出音量 和录音时间显示
    func meterChange() {
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
    
    //播放进度
    func progressShow() {
        
        if audioPlayer.duration > 0{
            let progress = audioPlayer.currentTime / audioPlayer.duration
            playProgressView.setProgress(Float(progress), animated: true)
        }
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
    
    //开始播放
    func play() {
        //暂停录音
        if (audioRecorder.isRecording){
            startButton.isSelected = !startButton.isSelected
        }
        audioRecorder.stop()
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.play()
            audioPlayer.delegate = self
            progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(progressShow), userInfo: nil, repeats: true)
            progressTimer?.fire()
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.isSelected = !playButton.isSelected
        playProgressView.setProgress(0, animated: false)
    }
    
    func confrimClick() {
        
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
            sender.isSelected = !sender.isSelected
        }else{
            if audioRecorder.currentTime > 0 {
                play()
                sender.isSelected = !sender.isSelected
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch  {
        }
        readyForRecorder()
        timeLabel.text = "00:00:00.00"
    }
}

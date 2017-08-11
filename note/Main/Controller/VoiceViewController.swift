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
    
    
    
    var audioRecorder:AVAudioRecorder!
    var ducidoPlayer:AVAudioPlayer!
    
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
            audioRecorder.prepareToRecord()//准备录音
        } catch {
        }
        
    }

    func directoryURL() -> URL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        return soundURL
    }

    @IBAction func recordingClick(_ sender: UIButton) {
        
    }
    
    @IBAction func playClick(_ sender: UIButton) {
    }
    
}

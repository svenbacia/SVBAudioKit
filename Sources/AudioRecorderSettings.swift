//
//  AudioRecorderSettings.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 26/11/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation
import AVFoundation

public typealias AudioRecorderSettings = [ String : NSNumber ]

let defaultAudioRecorderSettings = [
  AVFormatIDKey : Int(kAudioFormatMPEG4AAC) as NSNumber,
  AVSampleRateKey : AVAudioSession.sharedInstance().sampleRate as NSNumber,
  AVNumberOfChannelsKey : 2,
  AVEncoderBitRatePerChannelKey : 96_000,
  AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue as NSNumber
]
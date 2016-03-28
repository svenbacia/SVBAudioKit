//
//  AudioRecorderDelegate.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 28.03.16.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation

public protocol AudioRecorderDelegate: class {
  func audioRecorderEncodeErrorDidOccur(recorder: AudioRecorder, error: NSError?)
}

//
//  AudioRecorder.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 02/09/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioRecorder: NSObject {
  
  public private(set) var fileName: String
  public private(set) var directory: NSURL
  
  public var path: NSURL {
    return directory.URLByAppendingPathComponent(fileName).URLByAppendingPathExtension("caf")
  }
  
  public var delegate: AudioRecorderDelegate?
  
  // MARK: -
  
  private var recorder: AVAudioRecorder!
  
  // MARK: -
  
  public var recording: Bool {
    return recorder.recording
  }
  
  public var meteringEnabled: Bool {
    set {
      recorder.meteringEnabled = newValue
    }
    get {
      return recorder.meteringEnabled
    }
  }
  
  // MARK: - Init
  
  public init(fileName: String = AudioRecorder.defaultFileName, url: NSURL = AudioRecorder.defaultPath, settings: AudioRecorderSettings = defaultAudioRecorderSettings) throws {
    
    self.directory = url
    self.fileName  = fileName

    super.init()
    
    recorder = try AVAudioRecorder(URL: path, settings: settings)
    recorder.delegate = self
    recorder.prepareToRecord()
  }
  
  deinit {
    deleteRecording()
  }
  
  // MARK: - Functions
  
  /// Starts or resumes recording.
  /// - returns `true` if successful, otherwise `false`
  public func record() -> Bool {
    return recorder.record()
  }
  
  /// Pauses a recording.
  /// Invoke the `record` method to resume recording.
  public func pause() {
    recorder.pause()
  }
  
  /// Stops recording and closes the audio file.
  public func stop() {
    recorder.stop()
  }
  
  /// Refreshes the average and peak power values for all channels of an audio recorder.
  /// - parameter channels: An array of integers that you want the peak and average power value for.
  /// - returns: An array of current peak and average power values for the specified channels.
  public func updateMetersForChannels(channels: [Int]) -> [(peakPower: Float, averagePower: Float)] {
    
    guard meteringEnabled else { return [] }
    
    recorder.updateMeters()
    
    let powers: [(peakPower: Float, averagePower: Float)] = channels.map {
      (recorder.peakPowerForChannel($0), recorder.averagePowerForChannel($0))
    }
    
    return powers
  }
  
  /// Refreshes the peak powervalues for all channels of an audio recorder.
  /// - parameter channels: An array of integers that you want the peak power value for.
  /// - returns: An array of current peak and average power values for the specified channels.
  public func updatePeakPower(channels: [Int]) -> [Float] {
    
    guard meteringEnabled else { return [] }
    
    recorder.updateMeters()
    
    return channels.map {
      recorder.peakPowerForChannel($0)
    }
  }
  
  /// Refreshes the average power values for all channels of an audio recorder.
  /// - parameter channels: An array of integers that you want the peak and average power value for.
  /// - returns: An array of current peak and average power values for the specified channels.
  public func updateAveragePower(channels: [Int]) -> [Float] {
    
    guard meteringEnabled else { return [] }
    
    recorder.updateMeters()
    
    return channels.map {
      recorder.averagePowerForChannel($0)
    }
  }
}

// Save / Delete Function

public extension AudioRecorder {
  
  /// Closes the audio file and moves the file to the new directory if needed.
  /// - parameter toURL: Moves the file to the `toURL`.
  func saveRecording(toURL: NSURL? = nil) throws {
    
    let destination = toURL ?? AudioRecorder.documentsDirectory.URLByAppendingPathComponent(fileName).URLByAppendingPathExtension("caf")
    
    do {
      try NSFileManager.defaultManager().moveItemAtURL(path, toURL: destination)
    } catch {
      print("Error moving file to destination url")
    }
  }
  
  /// Deletes a recorded audio file.
  /// - returns `true` if successful, otherwise `false`
  func deleteRecording() -> Bool {
    return recorder.deleteRecording()
  }
}

private extension AudioRecorder {
  static var defaultPath: NSURL {
    return NSURL(fileURLWithPath: NSTemporaryDirectory())
  }
  
  static var defaultFileName: String {
    return AudioRecorder.stringFromDate(NSDate())
  }
  
  static func stringFromDate(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyyMMdd_HHmmss_recording"
    return formatter.stringFromDate(date)
  }
  
  static var documentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls.last!
  }
}

extension AudioRecorder: AVAudioRecorderDelegate {
  public func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
    delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
  }
}

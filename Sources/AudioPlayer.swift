//
//  AudioPlayer.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 04/10/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import UIKit
import AVFoundation

public class AudioPlayer<Item: Playable>: NSObject, AVAudioPlayerDelegate {
  
  // MARK: - Public Variables
  public weak var delegate: AnyAudioPlayerDelegate<Item>?
  
  /// The item which is currently loaded / playing.
  public let item: Item
  
  /// A Boolean value that indicates whether the audio player is playing (true) or not (false). (read-only)
  public var playing: Bool {
    return player.playing
  }
  
  /// Specifies if the audio player should loop (`true`) the current audio file or not (`false`).
  public var loops: Bool {
    get {
      return player.numberOfLoops != 0
    }
    set {
      player.numberOfLoops = newValue ? -1 : 0
    }
  }
  
  /// If the sound is playing, currentTime is the offset into the sound of the current playback position. 
  /// If the sound is not playing, currentTime is the offset into the sound where playing would start.
  public var currentTime: NSTimeInterval {
    return player.currentTime
  }
  
  // MARK: - Private Variables
  private var player: AVAudioPlayer!
  
  // MARK: - Init
  public init(item: Item, delegate: AnyAudioPlayerDelegate<Item>? = nil) throws {
    
    self.item = item
    self.delegate = delegate
    
    super.init()
    
    do {
      player = try AVAudioPlayer(data: item.data)
    } catch {
      throw AudioPlayerError.InvalidData
    }
    
    if !player.prepareToPlay() {
      throw AudioPlayerError.CouldNotPrepareToPlay
    }
    
    player.delegate = self
  }
  
  // MARK: - Play / Pause / Stop
  
  /// Plays a sound asynchronously.
  public func play() -> PlaybackState {
    if player.play() {
      return .Playing
    }
    return .Stopped
  }
  
  /// Pauses playback; sound remains ready to resume playback from where it left off.
  public func pause() -> PlaybackState {
    player.pause()
    return .Paused
  }
  
  /// Stops playing and undoes the setup for playback when `reset` is `true`. 
  /// - parameter reset: Undoes the playback setup when `true`; otherwise only reset the `currentTime`.
  public func stop(resetAudioFile reset: Bool = false) -> PlaybackState {
    if reset {
      player.stop()
    } else {
      player.pause()
      player.currentTime = 0.0
    }
    return .Stopped
  }
  
  /// Pauses the playback when the player is currently playing. Otherwise start playing.
  public func toggle() -> PlaybackState {
    if playing {
      return pause()
    } else {
      return play()
    }
  }
  
  // MARK: - AVAudioPlayerDelegate
  
  public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
    delegate?.audioPlayerDidFinishPlaying(self, successfully: flag)
  }
}

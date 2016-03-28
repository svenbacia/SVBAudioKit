//
//  AnyAudioPlayerDelegate.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 26/11/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation

public class AnyAudioPlayerDelegate<Item: Playable>: AudioPlayerDelegate {
  
  private let _audioPlayerDidFinsihPlaying: (AudioPlayer<Item>, Bool) -> Void
  
  public init<Delegate: AudioPlayerDelegate where Delegate.Item == Item>(_ delegate: Delegate) {
    _audioPlayerDidFinsihPlaying = { [weak delegate] player, flag in
      delegate?.audioPlayerDidFinishPlaying(player, successfully: flag)
    }
  }
  
  public func audioPlayerDidFinishPlaying(player: AudioPlayer<Item>, successfully flag: Bool) {
    _audioPlayerDidFinsihPlaying(player, flag)
  }
}

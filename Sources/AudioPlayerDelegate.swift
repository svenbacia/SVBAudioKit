//
//  AudioPlayerDelegate.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 26/11/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation

public protocol AudioPlayerDelegate: class {
  associatedtype Item: Playable
  func audioPlayerDidFinishPlaying(player: AudioPlayer<Item>, successfully flag: Bool)
}

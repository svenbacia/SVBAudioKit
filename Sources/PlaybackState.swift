//
//  PlaybackState.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 04/10/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation

/// Represents the current state of an audio file which is played by the `AudioPlayer`.
public enum PlaybackState {
  case Playing, Paused, Stopped
}

//
//  Playable.swift
//  SVBAudioKit
//
//  Created by Sven Bacia on 04/10/15.
//  Copyright © 2015 Sven Bacia. All rights reserved.
//

import Foundation

/// The `Playable` protocol provides minimal information about the audio file
/// which is played by the `AudioPlayer`.
public protocol Playable: Equatable {
  var identifier: String { get }
  var data: NSData { get }
}

public func ==<Item: Playable>(lhs: Item, rhs: Item) -> Bool {
  return lhs.identifier == rhs.identifier
}

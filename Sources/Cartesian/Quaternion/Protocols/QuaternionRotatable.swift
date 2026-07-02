//
//  QuaternionRotatable.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A type that can be rotated by a quaternion.
///
public protocol QuaternionRotatable {
	associatedtype QuaternionComponent: Real & SIMDScalar

/// Rotate this object by a quaternion, returning the rotated object.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate by.
///
/// - Returns: The rotated object.
///
	func rotated(by quaternion: Quaternion<QuaternionComponent>) -> Self
	
/// Rotate this object by a quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion to rotate by.
///
	mutating func rotate(by quaternion: Quaternion<QuaternionComponent>)
}

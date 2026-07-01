//
//  QuaternionConvertible.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

/// A type that can be converted to and from a quaternion.
///
public protocol QuaternionConvertible {
	associatedtype QuaternionComponent: Real & SIMDScalar

/// Initialize the object with the rotation of the quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion that will be used to initialize the
///   object.
///
	init(withQuaternion quaternion: Quaternion<QuaternionComponent>)

/// The object converted to a quaternion.
///
	var quaternion: Quaternion<QuaternionComponent> { get }
}

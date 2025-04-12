//
//  QuaternionMagnitude.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Quaternion`` that has a magnitude or length.
///
/// The magnitude represents the length of the quaternion in four-dimensional
/// space. Unit quaternions, commonly used for rotations, have a magnitude of
/// 1.
///
public protocol QuaternionMagnitude: Quaternion {
/// The magnitude or length of the quaternion.
///
/// The magnitude represents the length of the quaternion in four
/// dimensional space. Unit quaternions, commonly used for rotations, have
/// a magnitude of 1.
///
	var magnitude: Component { get set }
}

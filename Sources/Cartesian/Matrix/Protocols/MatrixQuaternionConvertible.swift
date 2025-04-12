//
//  MatrixQuaternionConvertible.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that can be converted to and from a ``Quaternion``.
///
public protocol MatrixQuaternionConvertible: Matrix {
/// The quaternion that the matrix can be converted to and from.
///
	associatedtype QuaternionRepresentation: Quaternion where QuaternionRepresentation.Component == Component
	
/// Initialize the rotational elements of the matrix using the provided
/// quaternion.
///
/// - Parameters:
///   - quaternion: The quaternion that will be used to initialize the
///   rotational elements of the matrix.
///
	init(withQuaternion quaternion: QuaternionRepresentation)
	
/// The rotational elements of the matrix as a quaternion.
///
	var quaternion: QuaternionRepresentation { get }
}

//
//  QuaternionMatrixConvertible.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Quaternion`` that can be converted to and from a ``Matrix``.
///
public protocol QuaternionMatrixConvertible: Quaternion {
/// The matrix that the quaternion can be converted to and from.
///
	associatedtype MatrixRepresentation: Matrix where MatrixRepresentation.Component == Component
	
/// Initialize the quaternion using the provided rotation matrix.
///
/// - Parameters:
///   - matrix: The matrix that will be used to initialize the quaternion.
///
	init(withMatrix matrix: MatrixRepresentation)
	
/// The quaternion as a rotation matrix.
///
	var matrix: MatrixRepresentation { get }
}

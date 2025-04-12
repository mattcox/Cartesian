//
//  Quaternion.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that represents a quaternion, describing a rotation in 3D space.
///
/// A quaternion consists of a real scalar component and a three-dimensional 
/// imaginary vector component. It is commonly used to represent rotations 
/// due to its compactness and ability to avoid issues like gimbal lock.
///
public protocol Quaternion {
/// The scalar type used for specifying the quaternion components.
///
	associatedtype Component: Numeric

/// The type used to store the imaginary vector part.
///
	associatedtype Imaginary: Vector3 where Imaginary.Component == Component
	
/// The type used to store the real scalar part.
///
	associatedtype Real = Component
	
/// The imaginary part of the quaternion.
///
	var imaginary: Imaginary { get set }
	
/// The real part of the quaternion.
///
	var real: Real { get set }
	
/// Initialize an empty quaternion.
///
	init()
	
/// Initialize a quaternion with a real and imaginary part.
///
/// - Parameters:
///   - imaginary: The imaginary part of the quaternion.
///   - real: The real part of the quaternion.
///
	init(imaginary: Imaginary, real: Real)
	
/// Initialize a quaternion with four components representing the imaginary
/// and real parts.
///
/// - Parameters:
///   - x: The first component of the imaginary part of the quaternion.
///   - y: The second component of the imaginary part of the quaternion.
///   - z: The third component of the imaginary part of the quaternion.
///   - real: The real part of the quaternion.
///
	init(imaginaryX x: Component, y: Component, z: Component, real: Real)
	
/// Initialize a quaternion with a vector containing the three components
/// of the imaginary part, and the fourth component representing the real
/// part of the quaternion.
///
/// - Parameters:
///   - vector: A vector describing the quaternion, with the first three
///   parts being imaginary, and the fourth being real.
///
	init<V: Vector4>(with vector: V) where V.Component == Component
	
/// Initialize a quaternion describing the rotation from one vector to
/// another.
///
/// - Parameters:
///   - from: A vector to rotate the quaternion from.
///   - to: A vector to rotate the quaternion to.
///
	init<V: Vector3>(from: V, to: V) where V.Component == Component
}

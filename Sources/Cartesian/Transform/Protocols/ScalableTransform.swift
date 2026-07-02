//
//  ScalableTransform.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A transform that can encode a scale within a Cartesian coordinate space.
///
/// Scaling resizes the space around its origin. The way a scale is expressed
/// depends on the class of transform: a similarity transform scales uniformly
/// and exposes its scale as a single scalar, whereas an affine transform can
/// scale each axis independently and exposes its scale as a vector.
///
/// The ``Scale`` associated type allows each conforming type to expose the
/// representation appropriate to the scaling it supports, independently of how
/// the scale is stored internally.
///
public protocol ScalableTransform: TransformProtocol {
/// The type used to express the scale encoded by the transform.
///
/// This is typically a scalar for transforms that scale uniformly, or a
/// vector for transforms that scale each axis independently.
///
	associatedtype Scale

/// The scale encoded by the transform.
///
	var scale: Scale { get set }
}

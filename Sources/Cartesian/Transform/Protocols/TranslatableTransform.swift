//
//  TranslatableTransform.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A transform that can encode a translation within a Cartesian coordinate
/// space.
///
/// Translation displaces a position along each axis without otherwise altering
/// the surrounding space. Rigid, similarity and affine transforms all support
/// translation.
///
/// The translation is exposed independently of how the conforming type stores
/// its components internally.
///
public protocol TranslatableTransform: TransformProtocol {
/// The translation, or displacement, encoded by the transform.
///
/// The translation is expressed as a vector describing the displacement
/// applied along each axis of the coordinate space.
///
	var translation: Vector { get set }
}

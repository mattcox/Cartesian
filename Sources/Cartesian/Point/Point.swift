//
//  Point.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A Point representing a position in 2D space.
///
/// The component can be any ``VectorComponent``, including integer types such as
/// `Int` and floating-point types such as `Double` or `Float`.
///
public typealias Point2<Component: VectorComponent> = Vector2<Component>

/// A Point representing a position in 3D space.
///
/// The component can be any ``VectorComponent``, including integer types such as
/// `Int` and floating-point types such as `Double` or `Float`.
///
public typealias Point3<Component: VectorComponent> = Vector3<Component>

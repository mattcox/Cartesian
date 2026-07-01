//
//  Point.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A Point representing a position in 2D space.
///
public typealias Point2<Component: Real & SIMDScalar> = Vector2<Component>

/// A Point representing a position in 3D space.
///
public typealias Point3<Component: Real & SIMDScalar> = Vector3<Component>

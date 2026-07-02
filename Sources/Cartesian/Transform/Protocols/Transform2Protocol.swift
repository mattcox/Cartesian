//
//  Transform2Protocol.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A transform that operates within a two-dimensional Cartesian coordinate
/// space.
///
/// This protocol refines ``TransformProtocol`` to fix the dimensionality of the
/// transform, mapping positions expressed as a ``Vector2`` and producing an
/// equivalent ``MatrixAffine3x3`` affine matrix. It carries no requirements of
/// its own beyond those it inherits; its purpose is to allow code to be written
/// generically over any class of two-dimensional transform - rigid, similarity
/// or affine - without binding to a specific concrete type.
///
/// For example, a function can accept any two-dimensional transform:
/// ```swift
/// func place(_ transform: some Transform2Protocol) { ... }
/// ```
///
public protocol Transform2Protocol: TransformProtocol where Component: Real & SIMDScalar, Vector == Vector2<Component>, Matrix == MatrixAffine3x3<Component> {

}

//
//  DepthRange.swift
//  Cartesian
//
//  Created by Matt Cox on 23/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// The range that a projection maps view space depth into, along the z axis of
/// normalized device coordinates, after the perspective divide.
///
/// Different rendering pipelines expect projected depth to fall within
/// different ranges. Selecting the range that matches the target pipeline
/// ensures that depth testing and clipping behave as intended. This is purely a
/// numeric convention; Cartesian expresses no preference for one over another.
///
public enum DepthRange: Sendable, Hashable, CaseIterable {
/// Depth is mapped into the range `[0, 1]`, where the near plane maps to `0`
/// and the far plane maps to `1`.
///
	case zeroToOne

/// Depth is mapped into the range `[-1, 1]`, where the near plane maps to `-1`
/// and the far plane maps to `1`.
///
	case negativeOneToOne
}

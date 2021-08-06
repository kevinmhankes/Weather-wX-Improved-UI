// **
// * Copyright (c) 2016 Razeware LLC
// *
// * Permission is hereby granted, free of charge, to any person obtaining a copy
// * of this software and associated documentation files (the "Software"), to deal
// * in the Software without restriction, including without limitation the rights
// * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// * copies of the Software, and to permit persons to whom the Software is
// * furnished to do so, subject to the following conditions:
// *
// * The above copyright notice and this permission notice shall be included in
// * all copies or substantial portions of the Software.
// *
// * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// * THE SOFTWARE.
// */

import Foundation
import simd
import SceneKit

extension float4x4 {
    
    init() {
        self = float4x4.init(1.0)
    }
    
    static func makeRotate(_ radians: Float, _ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        float4x4.init(SCNMatrix4MakeRotation(radians, x, y, z))
    }
    
    static func makeOrtho(_ left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float) -> float4x4 {
        let ral = right + left
        let rsl = right - left
        let tab = top + bottom
        let tsb = top - bottom
        let fan = farZ + nearZ
        let fsn = farZ - nearZ
        let col0 = SIMD4<Float>(2.0 / rsl, 0.0, 0.0, 0.0)
        let col1 = SIMD4<Float>(0.0, 2.0 / tsb, 0.0, 0.0)
        let col2 = SIMD4<Float>(0.0, 0.0, -2.0 / fsn, 0.0)
        let col3 = SIMD4<Float>(-ral / rsl, -tab / tsb, -fan / fsn, 1.0)
        return float4x4.init(col0, col1, col2, col3)
    }
    
    mutating func scale(_ x: Float, y: Float, z: Float) {
        self *= float4x4.init(diagonal: [x, y, z, 1.0])
    }
    
    mutating func rotateAroundX(_ x: Float, y: Float, z: Float) {
        var rotationM = float4x4.makeRotate(x, 1, 0, 0)
        rotationM = rotationM * float4x4.makeRotate(y, 0, 1, 0)
        rotationM = rotationM * float4x4.makeRotate(z, 0, 0, 1)
        self *= rotationM
    }
    
    mutating func translate(_ x: Float, y: Float, z: Float) {
        let col0 = SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
        let col1 = SIMD4<Float>(0.0, 1.0, 0.0, 0.0)
        let col2 = SIMD4<Float>(0.0, 0.0, 1.0, 0.0)
        let col3 = SIMD4<Float>(x, y, z, 1.0)
        self *= float4x4.init(col0, col1, col2, col3)
    }
    
    static func numberOfElements() -> Int {
        16
    }
    
    mutating func multiplyLeft(_ matrix: float4x4) {
        self = matrix * self
    }
}

/*
 Copyright 2013-present Roman Kushnarenko
 Licensed under the Apache License, Version 2.0 (the "License")
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 https://github.com/sromku/polygon-contains-point
 */

final class ExternalLine {

    private let start: ExternalPoint
    private let end: ExternalPoint
    private var a: Float = 999999999.0
    private var b: Float = 999999999.0
    private var vertical = false

    init(start: ExternalPoint, end: ExternalPoint) {
        self.start = start
        self.end = end
        if end.x - start.x != 0 {
            a = ((end.y - start.y) / (end.x - start.x))
            b = start.y - a * start.x
        } else {
            vertical = true
        }
    }

    func isInside(point: ExternalPoint) -> Bool {
        let maxX = start.x > end.x ? start.x : end.x
        let minX = start.x < end.x ? start.x : end.x
        let maxY = start.y > end.y ? start.y : end.y
        let minY = start.y < end.y ? start.y : end.y
        if (point.x >= minX && point.x <= maxX) && (point.y >= minY && point.y <= maxY) {
            return true
        }
        return false
    }

    func isVertical() -> Bool { vertical }
    
    func getA() -> Float { a }
    
    func getB() -> Float { b }
    
    func getStart() -> ExternalPoint { start }
    
    func getEnd() -> ExternalPoint { end }
    
    func toString() -> String { String(format: "%s-%s", start.toString(), end.toString()) }
}

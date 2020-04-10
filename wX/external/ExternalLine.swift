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

class ExternalLine {

    var  _start: ExternalPoint
    var  _end: ExternalPoint
    var  _a: Float = 999999999.0
    var  _b: Float = 999999999.0
    var _vertical = false

    init(start: ExternalPoint, end: ExternalPoint) {
        _start = start
        _end = end
        if _end.x - _start.x != 0 {
            _a = ((_end.y - _start.y) / (_end.x - _start.x))
            _b = _start.y - _a * _start.x
        } else {
            _vertical = true
        }
    }

    func isInside(point: ExternalPoint) -> Bool {
        let maxX = _start.x > _end.x ? _start.x : _end.x
        let minX = _start.x < _end.x ? _start.x : _end.x
        let maxY = _start.y > _end.y ? _start.y : _end.y
        let minY = _start.y < _end.y ? _start.y : _end.y
        if (point.x >= minX && point.x <= maxX) && (point.y >= minY && point.y <= maxY) {
            return true
        }
        return false
    }

    func isVertical() -> Bool { _vertical }
    
    func getA() -> Float { _a }
    
    func getB() -> Float { _b }
    
    func getStart() -> ExternalPoint { _start }
    
    func getEnd() -> ExternalPoint { _end }
    
    func toString() -> String { String(format: "%s-%s", _start.toString(), _end.toString()) }
}

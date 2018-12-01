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

/**
 * Point on 2D landscape
 *
 * @author Roman Kushnarenko (sromku@gmail.com)</br>
 */
public class ExternalPoint {

    var x: Float
    var y: Float

    init() {
        self.x = 0.0
        self.y = 0.0
    }

    init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }

    func toString() -> String {return String(format: "(%.2f,%.2f)", x, y)}
}

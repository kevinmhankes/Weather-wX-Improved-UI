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
 * The 2D polygon. <br>
 *
 * @see {@link Builder}
 * @author Roman Kushnarenko (sromku@gmail.com)
 */
final class ExternalPolygon {
    
    private let boundingBox: BoundingBox
    private let sides: [ExternalLine]

    init(sides: [ExternalLine], boundingBox: BoundingBox) {
        self.sides = sides
        self.boundingBox = boundingBox
    }

    /**
     * Get the builder of the polygon
     *
     * @return The builder
     */
    static func  BuilderS() -> Builder { Builder() }

    /**
     * Builder of the polygon
     *
     * @author Roman Kushnarenko (sromku@gmail.com)
     */
    final class Builder {
        private var _vertexes: [ExternalPoint] = []
        private var _sides: [ExternalLine] = []
        private var _boundingBox = BoundingBox()
        private var _firstPoint = true
        private var _isClosed = false

        /**
         * Add vertex points of the polygon.<br>
         * It is very important to add the vertexes by order, like you were drawing them one by one.
         *
         * @param point
         *            The vertex point
         * @return The builder
         */
        func addVertex(point: ExternalPoint ) -> Builder {
            if _isClosed {
                // each hole we start with the new array of vertex points
                _vertexes = []
                _isClosed = false
            }
            updateBoundingBox(point: point)
            _vertexes.append(point)
            // add line (edge) to the polygon
            if _vertexes.count > 1 {
                let line =  ExternalLine(start: _vertexes[ _vertexes.count - 2], end: point)
                _sides.append(line)
            }
            return self
        }

        /**
         * Close the polygon shape. This will create a new side (edge)
         * from the <b>last</b> vertex point to the <b>first</b> vertex point.
         *
         * @return The builder
         */
        func close() -> Builder {
            validate()
            // add last Line
            _sides.append(ExternalLine(start: _vertexes[ _vertexes.count - 1], end: _vertexes[0]))
            _isClosed = true
            return self
        }

        /**
         * Build the instance of the polygon shape.
         *
         * @return The polygon
         */
        func build() -> ExternalPolygon {
            validate()
            // in case you forgot to close
            if !_isClosed {
                // add last Line
                _sides.append(ExternalLine(start: _vertexes[ _vertexes.count - 1], end: _vertexes[0]))
            }
            let polygon =  ExternalPolygon(sides: _sides, boundingBox: _boundingBox)
            return polygon
        }

        /**
         * Update bounding box with a new point.<br>
         *
         * @param point
         *            New point
         */
        func updateBoundingBox(point: ExternalPoint ) {
            if _firstPoint {
                _boundingBox =  BoundingBox()
                _boundingBox.xMax = point.x
                _boundingBox.xMin = point.x
                _boundingBox.yMax = point.y
                _boundingBox.yMin = point.y
                _firstPoint = false
            } else {
                // set bounding box
                if point.x > _boundingBox.xMax {
                    _boundingBox.xMax = point.x
                } else if point.x < _boundingBox.xMin {
                    _boundingBox.xMin = point.x
                }
                if point.y > _boundingBox.yMax {
                    _boundingBox.yMax = point.y
                } else if point.y < _boundingBox.yMin {
                    _boundingBox.yMin = point.y
                }
            }
        }

        func validate() {
            if _vertexes.count < 3 {
                //throw new RuntimeException("Polygon must have at least 3 points")
            }
        }
    }

    /**
     * Check if the the given point is inside of the polygon.<br>
     *
     * @param point
     *            The point to check
     * @return <code>True</code> if the point is inside the polygon, otherwise return <code>False</code>
     */
    func contains(point: ExternalPoint) -> Bool {
        if inBoundingBox(point: point) {
            let ray = createRay(point: point)
            var intersection = 0
            for side in sides {
                if intersect(ray, side) { intersection += 1 }
            }
            /*
             * If the number of intersections is odd, then the point is inside the polygon
             */
            if intersection % 2 == 1 { return true }
        }
        return false
    }

    func getSides() -> [ExternalLine] { sides }

    /**
     * By given ray and one side of the polygon, check if both lines intersect.
     *
     * @param ray
     * @param side
     * @return <code>True</code> if both lines intersect, otherwise return <code>False</code>
     */
    func intersect(_ ray: ExternalLine, _ side: ExternalLine) -> Bool {
        var intersectPoint = ExternalPoint()
        // if both vectors aren't from the kind of x=1 lines then go into
        if !ray.isVertical() && !side.isVertical() {
            // check if both vectors are parallel. If they are parallel then no intersection point will exist
            if ray.getA() - side.getA() == 0 { return false }
            let x = ((side.getB() - ray.getB()) / (ray.getA() - side.getA())) // x = (b2-b1)/(a1-a2)
            let y = side.getA() * x + side.getB() // y = a2*x+b2
            intersectPoint = ExternalPoint(x, y)
        } else if ray.isVertical() && !side.isVertical() {
            let x = ray.getStart().x
            let y = side.getA() * x + side.getB()
            intersectPoint =  ExternalPoint(x, y)
        } else if !ray.isVertical() && side.isVertical() {
            let x = side.getStart().x
            let y = ray.getA() * x + ray.getB()
            intersectPoint =  ExternalPoint(x, y)
        } else {
            return false
        }
        // System.out.println("Ray: " + ray.toString() + " ,Side: " + side)
        // System.out.println("Intersect point: " + intersectPoint.toString())
        if side.isInside(point: intersectPoint) && ray.isInside(point: intersectPoint) {
            return true
        }
        return false
    }

    /**
     * Create a ray. The ray will be created by given point and on point outside of the polygon.<br>
     * The outside point is calculated automatically.
     * 
     * @param point
     * @return
     */
    func createRay(point: ExternalPoint) -> ExternalLine {
        // create outside point
        let epsilon = (boundingBox.xMax - boundingBox.xMin) / 100.0
        let outsidePoint =  ExternalPoint(boundingBox.xMin - epsilon, boundingBox.yMin)
        let vector =  ExternalLine(start: outsidePoint, end: point)
        return vector
    }

    /**
     * Check if the given point is in bounding box
     * 
     * @param point
     * @return <code>True</code> if the point in bounding box, otherwise return <code>False</code>
     */
    func  inBoundingBox(point: ExternalPoint) -> Bool {
        if point.x < boundingBox.xMin
            || point.x > boundingBox.xMax
            || point.y < boundingBox.yMin
            || point.y > boundingBox.yMax {
            return false
        }
        return true
    }

    class BoundingBox {
        var xMax = -Float.infinity
        var xMin = -Float.infinity
        var yMax = -Float.infinity
        var yMin = -Float.infinity
    }
    
    static func polygonContainsPoint(_ latLon: LatLon, _ latLons: [LatLon]) -> Bool {
        let polygonFrame = ExternalPolygon.Builder()
        latLons.forEach { _ = polygonFrame.addVertex(point: ExternalPoint($0)) }
        let polygonShape = polygonFrame.build()
        let contains = polygonShape.contains(point: latLon.asPoint())
        return contains
    }
}

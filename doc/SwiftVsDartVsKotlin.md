[[_TOC_]]

### Types and type conversion
Dart:
```dart
lon = double.tryParse(string.substring(4, 6) + "." + string.substring(6, 7)) ??  0.0;
```
Swift:
```swift
let d = Double("10.3") ?? 0.0
let i = Int("3") ?? 0
let s = String(10.3)

Bool, UInt8, Int64, float, CGFloat
```
Kotlin:
```kotlin
y = newValue.toDoubleOrNull() ?: 0.0
```
Groovy:
```groovy
// surround with try {} catch (Exception e) {}
d = Double.parseDouble(s)
```
```swift
removeAt
remove(at:)
```
### Function signature
Dart:
```dart
static List<double> parseLatLon(String string) {
```
Swift:
```swift
# use "_" to not require the named arg
static private func parseLatLon(_ string: String) -> [Double] {
```
Kotlin:
```kotlin
fun addColdFrontTriangles(front: Fronts, tokens: List<String>) {
```
Groovy:
```groovy
static void addColdFrontTriangles(Fronts front, List<String> tokens) {
```

### Char at index in String
Swift:
```swift
let index = string.index(string.startIndex, offsetBy: 3)
String(string[index])   
```
### for loop
Dart:
```dart
for (int index = 0; index < tokens.length; index += 1) {
UtilityWpcFronts.pressureCenters.asMap().forEach((index, value) {
```
Swift:
```
warningDataList.enumerated().forEach { index, warningData in
for (index, warningData) in warningDataList.enumerated() {
for index in stride(from: 0, to: tokens.count, by: 2) {
for index in aList.indices {
(7...10)
(7..<10)
```
Kotlin:
```
for (v in values) {
tokens.indices.forEach { index ->
bitmaps.forEachIndexed { index, bitmap ->
```
Groovy:
```
for (v in values) {
for (String v : values) {
for (int i : 0..totalBins) {
for (int i : 0..<totalBins) {
for (int i = 0; i < len; i += 1) {
tokens.indices.each { index ->
bitmaps.eachWithIndex { bitmap, index ->
```
Kotlin:
```
(100 downTo -1 step 1).forEach {
(0 until 256).forEach {
(0..159).forEach {
for (index in startIndex until tokens.size step indexIncrement) {
for (index in startIndex..tokens.size step indexIncrement) {
```
### swift - modify list passed as arg to method (inout and &)
```swift
func showTextWarnings(_ views: inout [UIView]) {
self.showTextWarnings(&views)
```
### List Size and range of int
Dart:
```dart
alist.length
```
swift
```swift
alist.count
alist.indices
alist.isEmpty
```
kotlin
```kotlin
alist.size
```
groovy
```groovy
alist.size()
```

### List add single value or a sequence
Dart
```dart
alist.add(v)
```
Swift
```swift
alist.append(v)
list1.append(contentsOf: list2)
list1 += list2
```
kotlin
```kotlin
alist.add(v)
```
groovy
```groovy
alist.add(v)
alist.addAll(vList)
```

### get the last, first, or start/end items in a list
swift
```swift
alist.first!
alist.last!
alist.prefix(5)
alist.suffix(5)
```
kotlin
```kotlin
alist.first()
alist.last()
alist.take(5)
alist.takeLast(5)
```
groovy
```groovy
alist.first()
alist.last()
alist.take(5)
alist.takeRight(5)
```

### Floor
swift
```swift
let numberOfTriangles = (distance / length).floor()
var x = 6.5
x.round(.towardZero)
```
Kotlin
```kotlin
import kotlin.math.floor
val numberOfTriangles = floor(distance / length)
```

### Math - PI
dart:
```
math.pi
```
Swift:
```
Double.pi
```
Kotlin:
```
import kotlin.math.*
PI
```
Swift
```swift
let varName:CLong = 0
```
Kotlin
```kotlin
var varName = 0.toLong()
```

### List initialization
Kotlin 
```kotlin
val blist = listOf(1, 2, 3)
var alist = mutableListOf("")
var alist = MutableList<String>()
val alist = MutableList<Int>(10, { it * 3 })
```
Swift
```swift
var alist = [String]()
var alist: [String] = []
var bitmaps = [Bitmap](repeating: Bitmap(), count: 10)
```
Dart
```dart
<String>[]
List<String>
```
### Dictionary
kotlin
```kotlin
val classToId: MutableMap<String, String> = mutableMapOf()

val sectorToName = mapOf(
    "FD" to "Full Disk: GOES-EAST",
    "FD-G17" to " Full Disk: GOES-WEST"
)

val size = sizeMap[sector] ?: fullSize

for (size in sizeMap.keys) {

val b = sizeMap.containsKey("test")
```
swift
```swift
var classToId: [String: String] = [:]
var classToId = [String: String]()

d.keys.forEach { key in
    someString += d[key]! + ": " + key
}

let s = provinceToMosaicSector[province] ?? ""
```
groovy
```groovy
static Map<String, String> sizeMap = [:]
static Map<String, String> sizeMap = ["small": "100", "medium": "200"]
sectorToLatLon.put("cgl", new LatLon(39.123405, -82.532938)) // cgl wellston, Oh
sizeMap.each { size, number ->
sizeMap.eachWithIndex { item, number -> println(item.key + " " + item.value)

```
dart
```dart
var classToId = Map<int, List<double>>();
```

### Iterate over enum:
kotlin
```kotlin
enum class RadarProduct {
    vel,
    ref,
    dvl,
}
NhcOceanEnum.values().forEach {}
```
groovy
```groovy
enum RadarProduct {
    vel,
    ref,
    dvl,
}
for (item in NhcOceanEnum.values()) {
NhcOceanEnum.values().each {}
```
swift
```swift
enum RadarProduct: CaseIterable {
    case vel
    case ref
    case dvl
}
let num = RadarProduct.allCases.count
for product in RadarProduct.allCases {
    print(product)
}
```
dart
```dart
enum RadarProduct {
    vel,
    ref,
    dvl,
}
for (var product in RadarProduct.values) {
    print(product);
}
```
### Passing functions as arguments
kotlin
```kotlin
var functions: List<(Int) -> Unit>
bottomSheetFragment.functions = listOf(::edit, ::delete, ::moveUp, ::moveDown)
    fun setListener(context: Context, drw: ObjectNavDrawer, fn: () -> Unit) {
    img.setListener(this, drw, ::getContentFixThis)
```
swift
```swift
var renderFn: ((Int) -> Void)?
self.renderFn!(paneNumber)
func setRenderFunction(_ fn: @escaping (Int) -> Void) {
        self.renderFn = fn
}
```
dart
```dart
Function(int) fn
```

### switch statement
kotlin (when)
```kotlin
when (day) {
    "1", "2" -> {
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}otlk_$time.gif")
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_torn.gif")
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_hail.gif")
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day${day}probotlk_" + time + "_wind.gif")
    }
    "3" -> {
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day3otlk_$time.gif")
        imgUrls.add(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day3prob_$time.gif")
    }
    else -> {
    }
}
```
swift
```swift
switch day {
case "1", "2":
    let baseUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
    urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".gif")
    let z1 = ["_torn.gif", "_hail.gif", "_wind.gif"]
    for urlEnd in z1 {
        urls.append(baseUrl + time + urlEnd)
    }
case "3":
    let z2 = ["otlk_", "prob_"]
    for urlEnd in z2 {
        urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + urlEnd + time + ".gif")
    }
default:
    break
}

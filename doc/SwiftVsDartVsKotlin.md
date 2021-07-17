[[_TOC_]]

### Parse a string and return a double with error checking
Dart:
```dart
lon = double.tryParse(string.substring(4, 6) + "." + string.substring(6, 7)) ??  0.0;
```
Swift:
```swift
let tempD = Double(value) ?? 0.0
```
Kotlin:
```kotlin
y = newValue.toDoubleOrNull() ?: 0.0
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

### Char at index in String
Swift:
```swift
let index = string.index(string.startIndex, offsetBy: 3)
String(string[index])   
```
### for loop index iterate
Dart:
```dart
for (int index = 0; index < tokens.length; index += 1) {
UtilityWpcFronts.pressureCenters.asMap().forEach((index, value) {
```
Swift:
```
warningDataList.enumerated().forEach { index, warningData in
for index in stride(from: 0, to: tokens.count, by: 2) {
```
Kotlin:
```
tokens.indices.forEach { index ->
```
Kotlin:
```
(100 downTo -1 step 1).forEach {
(0 until 256).forEach {
(0..159).forEach {
for (index in startIndex until tokens.size step indexIncrement) {
for (index in startIndex..tokens.size step indexIncrement) {
```
Swift:
```
(7...10)
(7..<10)
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
```
kotlin
```kotlin
alist.size
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

### get the last, first, or start/end items in a list
swift
```swift
list1.first!
list1.last!
list1.suffix(5)
list1.prefix(5)
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
mutableListOf("")
MutableList<String>
```
Swift
```swift
var aList = [String]()
var aList: [String] = []
var bitmaps = [Bitmap](repeating: Bitmap(), count: 10)
```
Dart
```dart
<String>[]
List<String>
```
### forEach loop with both index and value
Kotlin
```kotlin
list.forEachIndexed { index, value ->
```
Dart
```dart
list.asMap().forEach((index, value) => f);
```
Swift
```swift
list.enumerated().forEach { index, value in
for (index, value) in list.enumerated() {
```
### Dictionary
kotlin
```kotlin
val classToId: MutableMap<String, String> = mutableMapOf()
```
swift
```swift
var classToId: [String: String] = [:]
var classToId = [String: String]()

d.keys.forEach { key in
    someString += d[key]! + ": " + key
}
```
dart
```dart
var classToId = Map<int, List<double>>();
```

### Iterate over enum:
```
kotlin:
NhcOceanEnum.values().forEach {}
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

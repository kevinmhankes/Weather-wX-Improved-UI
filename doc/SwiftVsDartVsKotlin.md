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

removeAt
remove(at:)

### Function signature
Dart:
```dart
static List<double> parseLatLon(String string) {
```
Swift:
```swift
static func parseLatLon(_ string: String) -> [Double] {
```
Kotlin:
```kotlin
fun addColdFrontTriangles(front: Fronts, tokens: List<String>) {
```

### Char at index in String
Swift:
let index = string.index(string.startIndex, offsetBy: 3)
String(string[index])   

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
Swift - modify list passed as arg to method (inout and &)

func showTextWarnings(_ views: inout [UIView]) {
self.showTextWarnings(&views)

### List Size
Dart:
length

swift:
count

### List add to
Dart:
add

Swift:
append
# add sequence to end
list1 = append(contentsOf: list2)
list1 += list2

# get the last or first 5 items in a list
list1.suffix(5)
list1.prefix(5)


### Floor
let numberOfTriangles = (distance / length).floor()

var x = 6.5
x.round(.towardZero)

Kotlin:
import kotlin.math.floor
val numberOfTriangles = floor(distance / length)


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
Swift: let varName:CLong = 0
Kotlin var varName = 0.toLong()


### List initialization
```
Kotlin: mutableListOf("")     MutableList<String>
Swift [String]()       [String]
Dart <String>[]      List<String>
```
### forEach loop with both index and value
```
Kotlin:
list.forEachIndexed { index, value ->

Dart:
list.asMap().forEach((index, value) => f);

Swift:
list.enumerated().forEach { index, value in
```
### Dictionary
```
kotlin:
val classToId: MutableMap<String, String> = mutableMapOf()

swift:
var classToId: [String: String] = [:]
var classToId = [String: String]()

dart:
var classToId = Map<int, List<double>>();
```

Iterate over enum:
```
kotlin:
NhcOceanEnum.values().forEach {}
```
Passing functions
```
kotlin:
var functions: List<(Int) -> Unit>
bottomSheetFragment.functions = listOf(::edit, ::delete, ::moveUp, ::moveDown)
    fun setListener(context: Context, drw: ObjectNavDrawer, fn: () -> Unit) {
    img.setListener(this, drw, ::getContentFixThis)

swift:
var renderFn: ((Int) -> Void)?
self.renderFn!(paneNumber)

func setRenderFunction(_ fn: @escaping (Int) -> Void) {
        self.renderFn = fn
}

dart:
Function(int) fn

```

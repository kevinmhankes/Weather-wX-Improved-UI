Parse a string and return a double with error checking
Dart:
lon = double.tryParse(string.substring(4, 6) + "." + string.substring(6, 7)) ??  0.0;

Swift:
let tempD = Double(value) ?? 0.0



Dart:
static List<double> parseLatLon(String string) {

Swift:
static func parseLatLon(_ string: String) -> [Double] {



Char at index in String
Swift:
let index = string.index(string.startIndex, offsetBy: 3)
String(string[index])   

for loop index iterate

Dart:
for (int index = 0; index < tokens.length; index += 1) {

Swift:
warningDataList.enumerated().forEach { index, warningData in



Swift - modify list passed as arg to method (inout and &)

func showTextWarnings(_ views: inout [UIView]) {
self.showTextWarnings(&views)




List Size
Dart:
length

swift:
count


List add to
Dart:
add

Swift:
append



Floor
let numberOfTriangles = (distance / length).floor()

var x = 6.5
x.round(.towardZero)


Math - PI
dart:
math.pi

Double.pi

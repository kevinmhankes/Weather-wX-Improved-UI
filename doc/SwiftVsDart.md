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

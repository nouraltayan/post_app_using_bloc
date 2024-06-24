// ../test/widget_test.dart
// This is a basic Flutter widget test.// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

void main() {
  String urlnot = "www.google.com/api/num/hello/scor";
  String url1 = "www.google.com/api/{name}/hello";
  String url2 = "www.google.com/api/hello/{score}";

  String url = "www.google.com/api/{name}/hello/{score}";
  Map<String, String> mapForTest = {"name": "Noor", "score": "30"};
  RegExp pattern = RegExp(r'.*/\{name\}/.*/\{score\}.*');
  RegExp pattern1 = RegExp(r'.*/\{name\}/.*');
  RegExp pattern2 = RegExp(r'.*/\{score\}.*');

  String replaceUrlFromMap(String link, Map<String, String> map) {
    if (pattern.hasMatch(link)) {
      if (map.isEmpty) {
        return link;
      } else {
        if (map["name"] != null) {
          link = link.replaceAll('{name}', map['name']!);
        }
        if (map["score"] != null) {
          link = link.replaceAll('{score}', map['score']!);
        }
        return link;
      }
    } else if (pattern1.hasMatch(link)) {
      if (map.isEmpty) {
        return link;
      } else {
        if (map["name"] != null) {
          link = link.replaceAll('{name}', map['name']!);
        }

        return link;
      }
    } else if (pattern2.hasMatch(link)) {
      if (map.isEmpty) {
        return link;
      } else {
        if (map["score"] != null) {
          link = link.replaceAll('{score}', map['score']!);
        }

        return link;
      }
    } else {
      return "the link is notvalid";
    }
  }

  test("The Happy Scinro of link valid", () {
    expect(
        replaceUrlFromMap(url, mapForTest), "www.google.com/api/Noor/hello/30");
  });
  test("The Happy Scinro of link notvalid", () {
    expect(replaceUrlFromMap(urlnot, mapForTest), "the link is notvalid");
  });

  test("The Happy Scinro of link name", () {
    expect(
        replaceUrlFromMap(url1, mapForTest), "www.google.com/api/Noor/hello");
  });

  test("The Happy Scinro of link score", () {
    expect(replaceUrlFromMap(url2, mapForTest), "www.google.com/api/hello/30");
  });

  test("The Happy Scinro of MyFunction", () {
    expect(
        replaceUrlFromMap(url, mapForTest), "www.google.com/api/Noor/hello/30");
  });

  test("The Map is Empty", () {
    expect(
        replaceUrlFromMap(url, {}), "www.google.com/api/{name}/hello/{score}");
  });

  test("The Map has one enrty ", () {
    expect(replaceUrlFromMap(url, {"name": "Noor"}),
        "www.google.com/api/Noor/hello/{score}");
  });

  test("The Map Has same Key", () {
    expect(
        replaceUrlFromMap(
            url, {"name": "Noor", "name": "Ahmad", "score": "30"}),
        "www.google.com/api/Ahmad/hello/30");
  });
}

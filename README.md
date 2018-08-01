# mockery

A simple Dart package containing recipes for mocking objects in Dart and Flutter

## Mocking HTTP Image Calls

The first (and currently only) recipe here mocks a http call destined to retrieve an image and returns a one pixel image without touching the network. This is great for testing Flutter widgets that hit the network with things like [Image.network](https://docs.flutter.io/flutter/widgets/Image/Image.network.html).

Wrap the code making the http call with [HttpOverrides.runZoned](https://docs.flutter.io/flutter/dart-io/HttpOverrides-class.html) and pass in a reference to ```createMockImageHttpClient```. 

```dart
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockery/mock_http_image.dart';

void main() {
  testWidgets('images are successfully mocked in http', (tester) async {
    HttpOverrides.runZoned(() async {
      await tester.pumpWidget(
          // The url doesn't matter, anything will do
          Image.network('https://www.example.com/images/image.png'));
    }, createHttpClient: createMockImageHttpClient);
  });
}
```
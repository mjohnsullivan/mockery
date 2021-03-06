// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

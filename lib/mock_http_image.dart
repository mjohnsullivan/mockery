// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Mocks out a http call that fetches an image; it will return a 1-pixel png
/// Taken from Flutter's source: https://github.com/flutter/flutter/blob/9f8a70be4cea69660ffc8bf48fe82a0f98d0ad23/packages/flutter/test/widgets/image_headers_test.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mockito/mockito.dart';

/// One pixel png image in base64
const String _b64Image =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

/// One pixel png image in bytes
final List<int> _image = base64.decode(_b64Image);

class _MockHttpClient extends Mock implements HttpClient {}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

/// Mocks out all http calls, returning a one pixel image.
/// To use this in a test, wrap the code making http calls in
/// [HttpOverrides.runZoned] and ensure that pass this function
/// to the createHttpClient parameter.
///
/// Example:
/// ```dart
/// testWidgets('images are successfully mocked in http', (tester) async {
///   HttpOverrides.runZoned(() async {
///     await tester.pumpWidget(
///        // The url doesn't matter, anything will do
///        Image.network('https://www.example.com/images/frame.png'));
///   }, createHttpClient: createMockImageHttpClient);
/// });
/// ```
///
_MockHttpClient createMockImageHttpClient(SecurityContext _) {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();

  when(client.getUrl(any))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));

  when(request.headers).thenReturn(headers);
  when(request.close())
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(response.contentLength).thenReturn(_image.length);
  when(response.statusCode).thenReturn(HttpStatus.OK);
  when(response.listen(any)).thenAnswer((Invocation invocation) {
    final void Function(List<int>) onData = invocation.positionalArguments[0];
    final void Function() onDone = invocation.namedArguments[#onDone];
    final void Function(Object, [StackTrace]) onError =
        invocation.namedArguments[#onError];
    final bool cancelOnError = invocation.namedArguments[#cancelOnError];
    return Stream<List<int>>.fromIterable(<List<int>>[_image]).listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  });
  return client;
}

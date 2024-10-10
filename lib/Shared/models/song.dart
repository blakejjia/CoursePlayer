// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'models.dart';

class Song {
  final String artist; // TODO: 类型变成 Artist
  final String title;
  final Duration length;
  final String image; // TODO:变成 image

  const Song( this.title, this.artist, this.length, this.image);
}

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:uuid/uuid.dart';

Future<Message> createMessage(
  String senderId,
  Dio dio, {
  bool? textOnly,
}) async {
  const uuid = Uuid();
  Message message;

  if (Random().nextBool() || textOnly == true) {
    message = TextMessage(
      id: uuid.v4(),
      senderId: senderId,
      timestamp: DateTime.now(),
      text: lorem(paragraphs: 1, words: Random().nextInt(30) + 1),
    );
  } else {
    final orientation = ['portrait', 'square', 'wide'][Random().nextInt(3)];
    late double width, height;

    if (orientation == 'portrait') {
      width = 200;
      height = 400;
    } else if (orientation == 'square') {
      width = 200;
      height = 200;
    } else {
      width = 400;
      height = 200;
    }

    final response = await dio.get(
      'https://whatever.diamanthq.dev/image?w=${width.toInt()}&h=${height.toInt()}&seed=${Random().nextInt(501)}',
      options: Options(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      ),
    );

    message = ImageMessage(
      id: uuid.v4(),
      senderId: senderId,
      timestamp: DateTime.now(),
      source: response.data['img'],
      thumbhash: response.data['thumbhash'],
    );
  }

  // return ImageMessage(
  //   id: uuid.v4(),
  //   senderId: senderId,
  //   timestamp: DateTime.now(),
  //   source:
  //       'https://www.hdcarwallpapers.com/walls/audi_r8_spyder_v10_performance_rwd_2021_4k_8k-HD.jpg',
  //   thumbhash: '2gcODIKwdmg9eId1l4qTb2v4xw',
  // );

  return message;
}

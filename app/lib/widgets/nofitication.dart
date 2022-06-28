import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void notification({required String title, required String body}) async {
  var rng = Random();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: rng.nextInt(100),
      channelKey: 'basic_channel',
      title: title,
      body: body,
    ),
  );
}

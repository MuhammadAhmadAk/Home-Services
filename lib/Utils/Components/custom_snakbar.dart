import 'dart:async';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

void showMessage(BuildContext context, String title, String msg) {
  ElegantNotification notification;

  if (title == "Error") {
    notification = ElegantNotification.error(
      width: 360,
      isDismissable: false,
      stackedOptions: StackedOptions(
        key: 'bottom',
        type: StackedType.below,
        itemOffset: Offset(-5, -5),
      ),
      title: Text(title),
      description: Text(msg),
      onDismiss: () {
        // Message when the notification is dismissed
      },
      onNotificationPressed: () {
        // Message when the notification is pressed
      },
      border: Border(
        bottom: BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  } else {
    notification = ElegantNotification.success(
      width: 360,
      isDismissable: false,
      stackedOptions: StackedOptions(
        key: 'bottom',
        type: StackedType.below,
        itemOffset: Offset(-5, -5),
      ),
      title: Text(title),
      description: Text(msg),
      onDismiss: () {
        // Message when the notification is dismissed
      },
      onNotificationPressed: () {
        // Message when the notification is pressed
      },
      border: Border(
        bottom: BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
    );
  }

  // Show the notification
  notification.show(context);

  // Set a timer to dismiss the notification after 3 seconds
  Timer(Duration(seconds: 3), () {
    notification.dismiss();
  });
}

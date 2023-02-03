import 'package:flutter/material.dart';

NotificationListener<ScrollNotification> scrollListenerWrapper(onScrollStart, onScrollEnd, child) {
  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification.metrics is! FixedExtentMetrics) {
        return false;
      }
      if (notification is ScrollEndNotification) {
        final selectedIndex = (notification.metrics as FixedExtentMetrics).itemIndex;
        onScrollEnd(selectedIndex);
      }
      if (notification is ScrollStartNotification) {
        onScrollStart();
      }

      // False allows the event to bubble up further
      return false;
    },
    child: child,
  );
}

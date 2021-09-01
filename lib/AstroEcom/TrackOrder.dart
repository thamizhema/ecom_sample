import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TrackOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: VxTimeline(
        timelineList: [
          VxTimelineModel(
              id: 2, heading: 'test Track', description: 'description'),
          VxTimelineModel(
              id: 2, heading: 'test Track', description: 'description'),
          VxTimelineModel(
              id: 2, heading: 'test Track', description: 'description'),
        ],
        animationDuration: Duration(seconds: 1),
      ),
    ));
  }
}

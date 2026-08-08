import 'package:flutter/material.dart';

import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// 이미지 자리
            Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text("Image"),
            ),

            const SizedBox(width: 16),

            /// 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    event.cameraId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(event.gender),

                  Text(event.age),

                  Text(event.appearance),

                  const SizedBox(height: 8),

                  Text(
                    event.occurredAt.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import '../models/event.dart';

final List<Event> dummyEvents = List.generate(
  20,
      (index) => Event(
    cameraId: 'CAM_001',
    occurredAt: DateTime(2026, 7, 25, 16, 30).subtract(
      Duration(minutes: index * 5),
    ),
    gender: index.isEven ? '남성' : '여성',
    age: '20대',
    appearance: '검은색 반팔, 청바지',
    cropImagePath: 'media/crops/test_img.jpg',
    trajectoryImagePath: 'media/crops/test_img.jpg',
    clipVideoPath: 'media/clips/test2.mp4',
  ),
);
import '../models/event.dart';

final List<Event> dummyEvents = List.generate(
  20,
      (index) => Event(
    cameraId: 'CAM_${(index % 3 + 1).toString().padLeft(3, '0')}',

    // 7월 21일 ~ 25일에 이벤트 분산
    occurredAt: DateTime(
      2026,
      7,
      21 + (index % 5),
      10 + (index % 8),
      index * 2,
    ),

    gender: index.isEven ? '남성' : '여성',
    age: index % 3 == 0 ? '20대' : '30대',
    appearance: index.isEven
        ? '검은색 반팔, 청바지'
        : '흰색 반팔, 검은색 바지',

    cropImagePath: 'media/crops/test_img.jpg',
    trajectoryImagePath: 'media/crops/test_img.jpg',
    clipVideoPath: 'media/clips/test2.mp4',
  ),
);
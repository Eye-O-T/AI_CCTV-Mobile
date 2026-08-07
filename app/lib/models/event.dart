class Event {
  final String cameraId;
  final DateTime occurredAt;
  final String gender;
  final String age;
  final String appearance;
  final String cropImagePath;
  final String trajectoryImagePath;
  final String clipVideoPath;

  const Event({
    required this.cameraId,
    required this.occurredAt,
    required this.gender,
    required this.age,
    required this.appearance,
    required this.cropImagePath,
    required this.trajectoryImagePath,
    required this.clipVideoPath,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      cameraId: json['camera_id'],
      occurredAt: DateTime.parse(json['occurred_at']),
      gender: json['gender'],
      age: json['age'],
      appearance: json['appearance'],
      cropImagePath: json['crop_image_path'],
      trajectoryImagePath: json['trajectory_image_path'],
      clipVideoPath: json['clip_video_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'camera_id': cameraId,
      'occurred_at': occurredAt.toIso8601String(),
      'gender': gender,
      'age': age,
      'appearance': appearance,
      'crop_image_path': cropImagePath,
      'trajectory_image_path': trajectoryImagePath,
      'clip_video_path': clipVideoPath,
    };
  }
}
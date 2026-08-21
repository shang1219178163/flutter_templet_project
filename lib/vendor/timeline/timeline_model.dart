///定义timeline list实体
class TimelineModel {
  const TimelineModel({
    required this.id,
    required this.title,
    required this.description,
    required this.day,
    required this.time,
  });
  final String id;
  final String title;
  final String description;
  final String day;
  final String time;
}

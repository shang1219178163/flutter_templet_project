

enum ActivityType {

  running(1, 'Running'),

  climbing(2, 'Climbing'),

  hiking(5, 'Hiking'),

  cycling(7, 'Cycling'),

  ski(10, 'Skiing'),

  unknown(-1, '');

  const ActivityType(this.number, this.value);

  final int number;

  final String value;

  static ActivityType getTypeByTitle(String title) => ActivityType.values.firstWhere((e) => e.name == title, orElse: () => ActivityType.unknown);

  static ActivityType getType(int number) => ActivityType.values.firstWhere((e) => e.number == number, orElse: () => ActivityType.unknown);

  static String getValue(int number) => getType(number).value;

  @override
  String toString() {
    return '$number is $value';
  }
}

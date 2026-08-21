class StudentClassroom {

  StudentClassroom({this.name, this.id});
  String? name;
  int? id;
}

class StudentTeacher {

  StudentTeacher({
    this.name,
    this.age,
  });
  String? name;
  int? age;
}

class Student {

  Student({
    this.score,
    this.teachers,
    this.name,
    this.classroom,
    this.id,
  });
  //JsonName:score
  int? score;

  //JsonName:teachers
  List<StudentTeacher>? teachers;

  //JsonName:name
  String? name;

  //JsonName:classroom
  StudentClassroom? classroom;

  //JsonName:id
  String? id;
}

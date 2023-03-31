

class StudentClassroom{
    String? name;
    int? id;

    StudentClassroom({
      this.name,
      this.id
    });
  }

  class StudentTeacher{
    String? name;
    int? age;

    StudentTeacher({
      this.name,
      this.age,
    });
  }

  class Student{
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

    Student({
      this.score,
      this.teachers,
      this.name,
      this.classroom,
      this.id,
    });
}

class Classroom{

	int id = 0;
	String name = '';


	/*
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	Classroom.fromJson(Map json){
		if(json.isEmpty){
			return;
		}
		name = json["name"].stringValue;
	}
	/*
	 * convert the instance properties values to json
	 */
	Map<String, dynamic> toJson(){
		var json = Map<String, dynamic>();
		json["name"] = name;
		return json;
	}


	/*  required initializer.  */
	Classroom({
		this.id,
		this.name
	});

}

class Teacher{

	int age = 0;
	String name = '';


	/*
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	Teacher.fromJson(Map json){
		if(json.isEmpty){
			return;
		}
		name = json["name"].stringValue;
	}
	/*
	 * convert the instance properties values to json
	 */
	Map<String, dynamic> toJson(){
		var json = Map<String, dynamic>();
		json["name"] = name;
		return json;
	}


	/*  required initializer.  */
	Teacher({
		this.age,
		this.name
	});

}

//
//	RootClass.dart
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport


class Student{

	Classroom classroom;
	String id = '';
	String name = '';
	int score = 0;
	List<Teacher> teachers;

	Student.fromJson(Map json){
		if(json.isEmpty){
			return;
		}
		final classroomJson = json["classroom"];
		if (!classroomJson.isEmpty){
			classroom = Classroom.fromJson(classroomJson);
		}
		id = json["id"].stringValue;
		name = json["name"].stringValue;
		teachers = [];
		final teachersArray = json["teachers"].arrayValue;
		for(var teachersJson in teachersArray){
			final value = Teacher.fromJson(teachersJson);
			teachers.add(value);
		}
	}

	Map<String, dynamic> toJson(){
		var json = Map<String, dynamic>();
		if (this.classroom != null) {
			json['classroom'] = this.classroom.toJson();
		}
		json["id"] = id;
		json["name"] = name;
		if (this.teachers != null) {
			json['teachers'] = this.teachers.map((v) => v.toJson()).toList();
		}
		return json;
	}


	/*  required initializer.  */
	Student({
		required this.classroom,
		required this.id,
		required this.name,
		required this.score,
		required this.teachers
	});

}

extension NumberParsing on String {
	int parseInt() {
		return int.parse(this);
	}
// ···
}
import 'package:cloud_firestore/cloud_firestore.dart';
class Project{
  String nameProject;
  String projectLeader;
  String email;
  String description;
  Timestamp dateStart;
  Timestamp dateEnd;

  Project({
    required this.nameProject,
    required this.projectLeader,
    required this.email,
    required this.description,
    required this.dateStart,
    required this.dateEnd,

  });
  Project.formJson(Map<String,Object>?json):this(
    nameProject: json?['nameProject']! as String,
    projectLeader: json?['projectLeader']! as String,
    email: json?['email']! as String,
    description: json?['description']! as String,
    dateStart: json?['dateStart']! as Timestamp,
    dateEnd: json?['dateEnd']! as Timestamp,
  );
  Project copyWith(
      {
        String? nameProject,
        String? projectLeader,
        String? email,
        String? description,
        Timestamp? dateStart,
        Timestamp? dateEnd,
      }){
    return Project(
      nameProject: nameProject??this.nameProject,
      projectLeader: projectLeader??this.projectLeader,
      email: email??this.email,
      description: description??this.description,
      dateStart: dateStart??this.dateStart,
      dateEnd: dateEnd??this.dateEnd,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'nameProject':nameProject,
      'projectLeader':projectLeader,
      'email':email,
      'description':description,
      'dateStart':dateStart,
      'dateEnd':dateEnd,
    };
  }
}
class Task{
  String idProject;
  String nameProject;
  String nameTask;
  String nameManagerTask;
  String description;
  bool statusTask;
  Timestamp dateStart;
  Timestamp dateEnd;


  Task({
    required this.idProject,
    required this.nameProject,
    required this.nameTask,
    required this.nameManagerTask,
    required this.description,
    required this.statusTask,
    required this.dateStart,
    required this.dateEnd,

  });
  Task.formJson(Map<String,Object>?json):this(
    idProject: json?['idProject']! as String,
    nameProject: json?['nameProject']! as String,
    nameTask: json?['nameTask']! as String,
    nameManagerTask: json?['nameManagerTask']! as String,
    description: json?['description']! as String,
    statusTask: json?['statusTask']! as bool,
    dateStart: json?['dateStart']! as Timestamp,
    dateEnd: json?['dateEnd']! as Timestamp,
  );
  Task copyWith(
      {
        String? idProject,
        String? nameProject,
        String? nameTask,
        String? nameManagerTask,
        String? description,
        bool? statusTask,
        Timestamp? dateStart,
        Timestamp? dateEnd,
      }){
    return Task(
      idProject: idProject??this.idProject,
      nameProject: nameProject??this.nameProject,
      nameTask: nameTask??this.nameTask,
      nameManagerTask: nameManagerTask??this.nameManagerTask,
      description: description??this.description,
      statusTask: statusTask??this.statusTask,
      dateStart: dateStart??this.dateStart,
      dateEnd: dateEnd??this.dateEnd,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idProject':idProject,
      'nameProject':nameProject,
      'nameTask':nameTask,
      'nameManagerTask':nameManagerTask,
      'description':description,
      'statusTask':statusTask,
      'dateStart':dateStart,
      'dateEnd':dateEnd,
    };
  }
}
class UserData{
  String displayName;
  String email;
  String password;
  String role;


  UserData({
    required this.displayName,
    required this.email,
    required this.password,
    required this.role,
  });
  UserData.formJson(Map<String,Object>?json):this(
    displayName: json?['displayName']! as String,
    email: json?['email']! as String,
    password: json?['password']! as String,
    role: json?['role']! as String,
  );
  UserData copyWith(
      {
        String? displayName,
        String? email,
        String?password,
        String?role,
      }){
    return UserData(
      displayName: displayName??this.displayName,
      email: email??this.email,
      password: password??this.password,
      role: role??this.role,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'displayName':displayName,
      'email':email,
      'password':password,
      'role':role,
    };
  }
}
class UserOfTask{
  String idTask;
  String idProject;
  String nameTask;
  String manager;
  String idEmployee;
  String nameEmployee;
  String email;


  UserOfTask({
    required this.idTask,
    required this.idProject,
    required this.nameTask,
    required this.manager,
    required this.idEmployee,
    required this.nameEmployee,
    required this.email,
  });
  UserOfTask.formJson(Map<String,Object>?json):this(
    idTask: json?['idTask']! as String,
    idProject: json?['idProject']! as String,
    nameTask: json?['nameTask']! as String,
    manager: json?['manager']! as String,
    idEmployee: json?['idEmployee']! as String,
    nameEmployee: json?['nameEmployee']! as String,
    email: json?['email']! as String,
  );
  UserOfTask copyWith(
      {
        String? idTask,
        String? idProject,
        String? nameTask,
        String? manager,
        String?idEmployee,
        String? nameEmployee,
        String?email,
      }){
    return UserOfTask(
      idTask: idTask??this.idTask,
      idProject: idProject??this.idProject,
      nameTask: nameTask??this.nameTask,
      manager: manager??this.manager,
      idEmployee: idEmployee??this.idEmployee,
      nameEmployee: nameEmployee??this.nameEmployee,
      email: email??this.email,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idTask':idTask,
      'idProject':idProject,
      'nameTask':nameTask,
      'manager':manager,
      'idEmployee':idEmployee,
      'nameEmployee':nameEmployee,
      'email':email,
    };
  }
}
class DailyReport{
  String idTask;
  String nameTask;
  String nameEmployee;
  String descriptionDailyReport;
  Timestamp timeReport;
  int statusReport;


  DailyReport({
    required this.idTask,
    required this.nameTask,
    required this.nameEmployee,
    required this.descriptionDailyReport,
    required this.timeReport,
    required this.statusReport,
  });
  DailyReport.formJson(Map<String,Object>?json):this(
    idTask: json?['idTask']! as String,
    nameTask: json?['nameTask']! as String,
    nameEmployee: json?['nameEmployee']! as String,
    descriptionDailyReport: json?['descriptionDailyReport']! as String,
    timeReport: json?['timeReport']! as Timestamp,
    statusReport: json?['statusReport']! as int,
  );
  DailyReport copyWith(
      {
        String? idTask,
        String? nameTask,
        String? manager,
        String? nameEmployee,
        String?descriptionDailyReport,
        Timestamp?timeReport,
        int?statusReport,
      }){
    return DailyReport(
      idTask: idTask??this.idTask,
      nameTask: nameTask??this.nameTask,
      nameEmployee: nameEmployee??this.nameEmployee,
      descriptionDailyReport: descriptionDailyReport??this.descriptionDailyReport,
      timeReport: timeReport??this.timeReport,
      statusReport: statusReport??this.statusReport,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idTask':idTask,
      'nameTask':nameTask,
      'nameEmployee':nameEmployee,
      'descriptionDailyReport':descriptionDailyReport,
      'timeReport':timeReport,
      'statusReport':statusReport,
    };
  }
}
class Comment{
  String idTask;
  String idUser;
  String idReport;
  String nameUser;
  String description;
  Timestamp time;

  Comment({
    required this.idTask,
    required this.idUser,
    required this.idReport,
    required this.nameUser,
    required this.description,
    required this.time,

  });
  Comment.formJson(Map<String,Object>?json):this(
    idTask: json?['idTask']! as String,
    idUser: json?['idUser']! as String,
    idReport: json?['idReport']! as String,
    nameUser: json?['nameUser']! as String,
    description: json?['description']! as String,
    time: json?['time']! as Timestamp,
  );
  Comment copyWith(
      {
        String? idTask,
        String? idUser,
        String? idReport,
        String? nameUser,
        String? description,
        Timestamp? time,
      }){
    return Comment(
      idTask: idTask??this.idTask,
      idUser: idUser??this.idUser,
      idReport: idUser??this.idReport,
      nameUser: nameUser??this.nameUser,
      description: description??this.description,
      time: time??this.time,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idTask':idTask,
      'idUser':idUser,
      'idReport':idReport,
      'nameUser':nameUser,
      'description':description,
      'time':time,
    };
  }
}
class Welfare{
  String nameWelfare;
  String description;
  Timestamp time;

  Welfare({
    required this.nameWelfare,
    required this.description,
    required this.time,

  });
  Welfare.formJson(Map<String,Object>?json):this(
    nameWelfare: json?['nameWelfare']! as String,
    description: json?['description']! as String,
    time: json?['time']! as Timestamp,
  );
  Welfare copyWith(
      {
        String? nameWelfare,
        String? description,
        Timestamp? time,
      }){
    return Welfare(
      nameWelfare: nameWelfare??this.nameWelfare,
      description: description??this.description,
      time: time??this.time,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'nameWelfare':nameWelfare,
      'description':description,
      'time':time,
    };
  }
}
class RegisterWelfare{
  String idWelfare;
  String nameWelfare;
  String emailUser;
  int statusRegister;

  RegisterWelfare({
    required this.idWelfare,
    required this.nameWelfare,
    required this.emailUser,
    required this.statusRegister,

  });
  RegisterWelfare.formJson(Map<String,Object>?json):this(
    idWelfare: json?['idWelfare']! as String,
    nameWelfare: json?['nameWelfare']! as String,
    emailUser: json?['emailUser']! as String,
    statusRegister: json?['statusRegister']! as int,
  );
  RegisterWelfare copyWith(
      {
        String? idWelfare,
        String? nameWelfare,
        String? emailUser,
        int? statusRegister,
      }){
    return RegisterWelfare(
      idWelfare: idWelfare??this.idWelfare,
      nameWelfare: nameWelfare??this.nameWelfare,
      emailUser: emailUser??this.emailUser,
      statusRegister: statusRegister??this.statusRegister,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idWelfare':idWelfare,
      'nameWelfare':nameWelfare,
      'emailUser':emailUser,
      'statusRegister':statusRegister,
    };
  }
}

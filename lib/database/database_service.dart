
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/manage.dart';
// const String TODO_COLLECTION_REF="db_posts";

class DatabaseService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseService(String TASK_COLLECTION_REF){
    _tasksRef=_fierstore.collection(TASK_COLLECTION_REF).withConverter<Task>(
        fromFirestore: (snapshots,_)=>Task.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (task,_)=>task.toJson());
  }
  Stream<QuerySnapshot> getTasks(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getfind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> getId(String taskId) async {
    try {
      await _tasksRef.doc(taskId).get();
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> updateTask(String taskId, Task task) async {
    try {
      await _tasksRef.doc(taskId).update(task.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> updateClTask(String taskId, bool statusTask) async {
    try {
      await _tasksRef.doc(taskId).update({'statusTask': statusTask});
      print('Task updated successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error updating Task: $error'); // Ghi log lỗi để debug
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _tasksRef.add(task);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksRef.doc(taskId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseProjectService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseProjectService(String TASK_COLLECTION_REF){
    _tasksRef=_fierstore.collection(TASK_COLLECTION_REF).withConverter<Project>(
        fromFirestore: (snapshots,_)=>Project.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (project,_)=>project.toJson());
  }
  Stream<QuerySnapshot> getProjects(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getfind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> getId(String taskId) async {
    try {
      await _tasksRef.doc(taskId).get();
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> updatProject(String taskId, Project task) async {
    try {
      await _tasksRef.doc(taskId).update(task.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> addProject(Project task) async {
    try {
      await _tasksRef.add(task);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteProject(String taskId) async {
    try {
      await _tasksRef.doc(taskId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseUserService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseUserService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<UserData>(
        fromFirestore: (snapshots,_)=>UserData.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (userdata,_)=>userdata.toJson());
  }
  Stream<QuerySnapshot> getUsers(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateUserData(String taskId, UserData userData) async {
    try {
      await _tasksRef.doc(taskId).update(userData.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> adUserData(UserData userData) async {
    try {
      await _tasksRef.add(userData);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteUserData(String userDataId) async {
    try {
      await _tasksRef.doc(userDataId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseEmployeesService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseEmployeesService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<UserOfTask>(
        fromFirestore: (snapshots,_)=>UserOfTask.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (userOfTask,_)=>userOfTask.toJson());
  }
  Stream<QuerySnapshot> gets(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateData(String taskId, Task task) async {
    try {
      await _tasksRef.doc(taskId).update(task.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> addData(UserOfTask userData) async {
    try {
      await _tasksRef.add(userData);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteData(String userDataId) async {
    try {
      await _tasksRef.doc(userDataId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseDailyReportService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseDailyReportService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<DailyReport>(
        fromFirestore: (snapshots,_)=>DailyReport.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (dailyReport,_)=>dailyReport.toJson());
  }
  Stream<QuerySnapshot> gets(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateData(String taskId, DailyReport report) async {
    try {
      await _tasksRef.doc(taskId).update(report.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> addData(DailyReport dailyReport) async {
    try {
      await _tasksRef.add(dailyReport);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }
  Future<void> deleteData(String userDataId) async {
    try {
      await _tasksRef.doc(userDataId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseCommentReportService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseCommentReportService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<Comment>(
        fromFirestore: (snapshots,_)=>Comment.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (comment,_)=>comment.toJson());
  }
  Stream<QuerySnapshot> gets(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateData(String taskId, DailyReport report) async {
    try {
      await _tasksRef.doc(taskId).update(report.toJson());
      print('Task updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating task: $error'); // Log the error for debugging
    }
  }
  Future<void> updateComment(String commentId, String newDescription) async {
    try {
      await _tasksRef.doc(commentId).update({'description': newDescription});
      print('Comment updated successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error updating comment: $error'); // Ghi log lỗi để debug
    }
  }
  Future<void> addData(Comment comment) async {
    try {
      await _tasksRef.add(comment);
      print('Task added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding task: $error'); // Log the error for debugging
    }
  }
  Future<void> deleteData(String userDataId) async {
    try {
      await _tasksRef.doc(userDataId).delete();
      print('Task deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting task: $error'); // Log the error for debugging
    }
  }
}
class DatabaseWelfareService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseWelfareService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<Welfare>(
        fromFirestore: (snapshots,_)=>Welfare.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (welfare,_)=>welfare.toJson());
  }
  Stream<QuerySnapshot> gets(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateData(String welfareId, Welfare report) async {
    try {
      await _tasksRef.doc(welfareId).update(report.toJson());
      print('Welfare updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating Welfare: $error'); // Log the error for debugging
    }
  }
  Future<void> updateComment(String commentId, String newDescription) async {
    try {
      await _tasksRef.doc(commentId).update({'description': newDescription});
      print('Welfare updated successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error updating Welfare: $error'); // Ghi log lỗi để debug
    }
  }
  Future<void> addData(Welfare welfare) async {
    try {
      await _tasksRef.add(welfare);
      print('Welfare added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding Welfare: $error'); // Log the error for debugging
    }
  }
  Future<void> deleteData(String welfareDataId) async {
    try {
      await _tasksRef.doc(welfareDataId).delete();
      print('Welfare deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting Welfare: $error'); // Log the error for debugging
    }
  }
}
class DatabaseRegisterWelfareService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _tasksRef;
  DatabaseRegisterWelfareService(String taskCollectionRef){
    _tasksRef=_fierstore.collection(taskCollectionRef).withConverter<RegisterWelfare>(
        fromFirestore: (snapshots,_)=>RegisterWelfare.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (welfare,_)=>welfare.toJson());
  }
  Stream<QuerySnapshot> gets(){
    return _tasksRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String searchName){
    return _tasksRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateData(String welfareId, RegisterWelfare report) async {
    try {
      await _tasksRef.doc(welfareId).update(report.toJson());
      print('Welfare updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating Welfare: $error'); // Log the error for debugging
    }
  }
  Future<void> updateWelfare(String commentId, int newDescription) async {
    try {
      await _tasksRef.doc(commentId).update({'statusRegister': newDescription});
      print('Welfare updated successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error updating Welfare: $error'); // Ghi log lỗi để debug
    }
  }
  Future<void> addData(RegisterWelfare RegisterWelfare) async {
    try {
      await _tasksRef.add(RegisterWelfare);
      print('Welfare added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding Welfare: $error'); // Log the error for debugging
    }
  }
  Future<void> deleteData(String welfareDataId) async {
    try {
      await _tasksRef.doc(welfareDataId).delete();
      print('Welfare deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting Welfare: $error'); // Log the error for debugging
    }
  }
}



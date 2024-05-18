import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:quanly_duan/models/manage.dart';

import '../../service/auth_service.dart';
import '../home/home_welfare_manager/home.dart';

class EmployeeListScreen extends StatefulWidget {
  final String role;
  final String id;
  final String idProject;
  final String nameTask;
  final String manager;
  const EmployeeListScreen({
    super.key,
    required this.role,
    required this.id,
    required this.idProject,
    required this.nameTask,
    required this.manager,
  });

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:_appBar(),
          body: TabBarView(
            children: [
              EmployeeInTask(idTask:widget.id,idProject:widget.idProject,nameTask:widget.nameTask),
              AllEmployees(role: widget.role,id:widget.id,idProject:widget.idProject,nameTask: widget.nameTask,manager:widget.manager,),
              // _messagesListView(),
              // _trending(),
            ],
          ),
        ),
      ),
    );
  }
  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Center(child: Text("See the staff",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back,color: Colors.white,),
      ),
      actions: const [
        Icon(Icons.confirmation_num_sharp,color: Colors.blue,)
      ],
      bottom:const TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab (child: Text("Staff on the project",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),),
          Tab (child: Text("All employees",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),),
        ],
      ),
    );
  }
}
class AllEmployees extends StatefulWidget {
  final String role;
  final String id;
  final String idProject;
  final String nameTask;
  final String manager;
  const AllEmployees({super.key,
    required this.role,
    required this.id,
    required this.idProject,
    required this.nameTask,
    required this.manager,
  });

  @override
  State<AllEmployees> createState() => _AllEmployeesState();
}

class _AllEmployeesState extends State<AllEmployees> {
  final DatabaseUserService _databaseUserService=DatabaseUserService('db_user');
  final DatabaseEmployeesService _databaseEmployeesService=DatabaseEmployeesService('db_employeesTask');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _databaseUserService.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List docs=snapshot.data?.docs ??[];
          print(docs);
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              String docId = doc!.id;
              print(doc['role']=='admin');
              return doc['role']!='admin'?
              Card(
                elevation: 5,
                color: const Color.fromARGB(255, 255, 255, 255),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name:  ${doc['displayName']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email:  ${doc['email']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                       ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          UserOfTask userData=UserOfTask(
                              idTask: widget.id,
                              idProject: widget.idProject,
                              nameTask: widget.nameTask,
                              manager: widget.manager,
                              idEmployee: docId,
                              nameEmployee: doc['displayName'],
                              email: doc['email']);
                          Fluttertoast.showToast(msg: "add employee success");
                          _databaseEmployeesService.addData(userData);
                          // Get.offAll(const BottomNavigationBarWidget());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue,
                          ),
                          child: const Text("Add employee",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ):
              Visibility(
                visible: doc['role']=='admin'?false:false,
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              'Name:  ${doc['displayName']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                UserOfTask userData=UserOfTask(
                                    idTask: widget.id,
                                    idProject: widget.idProject,
                                    nameTask: widget.nameTask,
                                    manager: widget.manager,
                                    idEmployee: docId,
                                    nameEmployee: doc['displayName'],
                                    email: doc['email']);
                                Fluttertoast.showToast(msg: "add employee success");
                                _databaseEmployeesService.addData(userData);
                                Get.offAll(HomeScreen(role:widget.role));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blue,
                                ),
                                child: const Text("Add employee",style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email:  ${doc['email']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            },);
        },);
  }
}

class EmployeeInTask extends StatefulWidget {
  final String idTask;
  final String idProject;
  final String nameTask;
  const EmployeeInTask({super.key,
    required this.idTask,
    required this.idProject,
    required this.nameTask});

  @override
  State<EmployeeInTask> createState() => _EmployeeInTaskState();
}

class _EmployeeInTaskState extends State<EmployeeInTask> {
  final DatabaseEmployeesService _databaseEmployeesService=DatabaseEmployeesService("db_employeesTask");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseEmployeesService.gets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List docs=snapshot.data?.docs ??[];
        print(docs);
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index];
            String docId = doc!.id;
            return Visibility(
              visible: widget.idTask==doc['idTask'],
              child: Card(
                elevation: 5,
                color: const Color.fromARGB(255, 255, 255, 255),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name: ${doc['nameEmployee']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${doc['email']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                     const Spacer(),
                      InkWell(
                        onTap: () {
                          _databaseEmployeesService.deleteData(docId);
                          Fluttertoast.showToast(msg: "Delete employee success");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue,
                          ),
                          child: const Text("Delete employee",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },);
      },);
  }
}

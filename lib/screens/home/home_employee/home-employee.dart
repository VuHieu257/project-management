import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/layout/screen_layout/app_layout.dart';

import '../../task/view_task/view_task.dart';

class HomeScreenEmployee extends StatefulWidget {
  final String role;
  const HomeScreenEmployee({
    super.key,
    required this.role,
  });

  @override
  State<HomeScreenEmployee> createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {

  final DatabaseEmployeesService _databaseEmployeesService=DatabaseEmployeesService('db_employeesTask');
  final DatabaseService _databaseService=DatabaseService('db_task');
  final user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    print(widget.role);
    return AppLayout(
        content: _buildMenuItem(),
        role:widget.role
    );
  }
  Widget _buildMenuItem() {
    return SizedBox(
      height: context.height,
      child: StreamBuilder(
        stream: _databaseService.getTasks(),
        // stream: _databaseEmployeesService.getFind('email', "${user!.email}"),
        builder: (context, snapshot) {
          List docTasks=snapshot.data?.docs ??[];
          return ListView.builder(
            itemCount: docTasks.length,
            itemBuilder: (context, index) {
              var docTask = docTasks[index];
              String docTaskId = docTask.id;
              return SizedBox(
                height: context.height*0.5,
                child: StreamBuilder(
                  stream: _databaseEmployeesService.gets(),
                  builder: (context, snapshot) {
                    List docEs=snapshot.data?.docs ??[];
                    return ListView.builder(
                        itemCount: docEs.length,
                        itemBuilder: (context, index) {
                          var doc = docEs[index];
                          String docId = doc.id;
                          // print(docTask['nameManagerTask']==doc['manager']);
                          print(doc['idTask']==docTaskId);
                          return Visibility(
                            visible:doc['idTask']==docTaskId,
                            child: InkWell(
                              onTap: () {
                                Get.to(ViewTask(
                                  role: widget.role,
                                  idTask: docTaskId,
                                  nameTask: docTask['nameTask'],
                                  nameEmployee: doc['nameEmployee'],
                                  manager: docTask['nameManagerTask'],
                                  description: docTask['description'],
                                  start: docTask['dateStart'],
                                  end:docTask['dateEnd'],
                                ));
                              },
                              child: Card(
                                elevation: 5,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Task Name:  ${docTask['nameTask']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text.rich(
                                          style: const TextStyle(fontSize: 16),
                                          TextSpan(
                                              children: [
                                                const TextSpan(text: 'Manager: ',
                                                ),
                                                TextSpan(
                                                    text:  '${docTask['nameManagerTask']}',
                                                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 19)
                                                )
                                              ]
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Text.rich(
                                          style: const TextStyle(fontSize: 16),
                                          TextSpan(
                                              children: [
                                                const TextSpan(text: 'Start day:  ',
                                                ),
                                                TextSpan(
                                                  text:  DateFormat("MM-dd-yyyy h:mm a").format(docTask?["dateStart"].toDate()),
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 18)
                                                )
                                              ]
                                          )
                                      ),
                                      const SizedBox(height: 5),
                                      Text.rich(
                                          style: const TextStyle(fontSize: 16),
                                          TextSpan(
                                              children: [
                                                const TextSpan(text: 'Deadline:  ',
                                                ),
                                                TextSpan(
                                                  text:  DateFormat("MM-dd-yyyy h:mm a").format(docTask?["dateEnd"].toDate()),
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 18)
                                                )
                                              ]
                                          )
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  },),
              );
            },);
        },
      ),
    );
  }
}

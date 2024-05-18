import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/screens/task/view_task/view_task.dart';
import 'package:quanly_duan/screens/employee/Employee.dart';
import 'package:quanly_duan/service/getX/getX.dart';
import '../../../layout/screen_layout/app_layout.dart';
import '../../task/edit_task/edit_task.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({
    super.key,
    required this.role,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
final DatabaseService _databaseService=DatabaseService("db_task");
final user=FirebaseAuth.instance.currentUser;
final RoleController roleController=Get.put(RoleController());
  @override
  Widget build(BuildContext context) {
    print(roleController.name.value);
    print(widget.role);
    return AppLayout(
      content: _buildMenuItem(),
      role: widget.role,
    );
  }
  Widget _buildMenuItem() {
    return SizedBox(
      child:StreamBuilder(
        stream: _databaseService.getTasks() ,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List docDatas=snapshot.data?.docs ??[];
          return ListView.builder(
              itemCount: docDatas.length,
              itemBuilder: (context, index) {
                var doc = docDatas[index];
                String docId = doc.id;
                return InkWell(
                  onTap: () {
                    Get.to(ViewTask(
                      role: widget.role,
                      nameEmployee: roleController.name.value,
                      idTask: docId,
                      nameTask: doc['nameTask'],
                      manager: doc['nameManagerTask'],
                      description: doc['description'],
                      start: doc['dateStart'],
                      end:doc['dateEnd'],
                    ));
                  },
                  child: Visibility(
                    visible: roleController.name.value==doc['nameManagerTask']||widget.role=='admin',
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
                                  'Task Name:  ${doc['nameTask']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton(
                                  iconColor: Colors.black54,
                                  iconSize: 30,
                                  itemBuilder: (context) =>
                                  [
                                    PopupMenuItem(child: InkWell(
                                      onTap: () => Get.to(EmployeeListScreen(role: widget.role,id:docId,idProject: docId,nameTask:doc['nameTask'],manager:doc["nameManagerTask"]),),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(width: 5,),
                                          Text("See the staff"),
                                        ],
                                      ),)),
                                    PopupMenuItem(child:
                                      InkWell(
                                        onTap: () {},
                                            // Get.to(
                                          //   EditTaskScreen(
                                          // role: widget.role,
                                          // id: docId,
                                          // task: doc['nameTask'],
                                          // manager: doc['nameManagerTask'],
                                          // description: doc['description'],
                                          // start: doc['dateStart'],
                                          // end: doc['dateEnd'],
                                        // )),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 5,),
                                            Text("Edit Task"),
                                          ],
                                        ),)
                                      ),
                                    PopupMenuItem(child: InkWell(onTap: () {
                                      Fluttertoast.showToast(msg: "Delete success");
                                      _databaseService.deleteTask(docId);
                                    },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 5,),
                                          Text("Delete"),
                                        ],
                                      ),)),
                                  ],)
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                                style: const TextStyle(fontSize: 16),
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Manager: ',
                                  ),
                                  TextSpan(
                                    text:  ' ${doc['nameManagerTask']}',
                                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 19)
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
                                          text:  DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateStart"].toDate()),
                                          style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18)
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
                                          text:  DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateEnd"].toDate()),
                                          style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18)
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
              },);
        },
      ),
    );
  }
}

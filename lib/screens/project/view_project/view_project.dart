import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:quanly_duan/service/getX/getX.dart';

import '../../employee/Employee.dart';
import '../../task/add_task/add_task.dart';
import '../../task/edit_task/edit_task.dart';
import '../../task/view_task/view_task.dart';
class ViewProject extends StatefulWidget {
  String role;
  String idProject;
  String nameTask;
  String manager;
  String description;
  Timestamp start;
  Timestamp end;
  ViewProject({
    super.key,
    required this.idProject,
    required this.nameTask,
    required this.manager,
    required this.description,
    required this.start,
    required this.end,
    required this.role,
  });

  @override
  State<ViewProject> createState() => _ViewProjectState();
}
class _ViewProjectState extends State<ViewProject> {
  final DatabaseService _databaseService=DatabaseService("db_task");
  final DatabaseEmployeesService databaseEmployeesService=DatabaseEmployeesService('db_employeesTask');
  TextEditingController textEditingControllerDailyReport=TextEditingController();
  final RoleController roleController=Get.put(RoleController());
  final user = FirebaseAuth.instance.currentUser;
  bool statusTask=false;
  bool statusProject=false;

  @override
  Widget build(BuildContext context) {
    print(widget.role);
    return Scaffold(
      appBar: _buildAppBar(role:widget.role),
      body: widget.role=='staff'?_buildBodyStaff():_buildBody(),
    );
  }
  PreferredSizeWidget _buildAppBar({required String role}) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Center(child: Text("View Project",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
      leading: InkWell(
        // onTap: () =>role=='admin'||role=='manager'? Get.offAll(HomeScreen(role: role,)):Get.offAll(const HomeScreenEmployee(role: 'staff',)),
        onTap: () =>Get.offAll(const BottomNavigationBarWidget()),
        child: const Icon(Icons.arrow_back,color: Colors.white,),
      ),
      actions: const [
        Icon(Icons.confirmation_num_sharp,color: Colors.blue,)
      ],
    );
  }
  Widget _buildBody() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    statusProject=!statusProject;
                  });
                },
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'View project',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Icon(statusProject?Icons.arrow_drop_up:Icons.arrow_drop_down_outlined,size: 30,)
                  ],
                ),
              ),
              Visibility(
                visible: statusProject,
                child:   const Divider(),),
              Visibility(
                visible: statusProject,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nameTask,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Leader: ${widget.manager}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                                child: Text(
                                  widget.description,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text.rich(
                              style: const TextStyle(fontSize: 16),
                              TextSpan(
                                  children: [
                                    const TextSpan(text: 'Start day:  ',
                                    ),
                                    TextSpan(
                                        text:  DateFormat("MM-dd-yyyy h:mm a").format(widget.start.toDate()),
                                        style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                                    )
                                  ]
                              )
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text.rich(
                              style: const TextStyle(fontSize: 16),
                              TextSpan(
                                  children: [
                                    const TextSpan(text: 'Deadline:  ',
                                    ),
                                    TextSpan(
                                        text:  DateFormat("MM-dd-yyyy h:mm a").format(widget.end.toDate()),
                                        style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                                    )
                                  ]
                              )
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )),
              const Divider(),
              InkWell(
                  onTap: () {
                    setState(() {
                      statusTask=!statusTask;
                    });
                  },
                  child: Row(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Tasks in the project',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Icon(statusTask?Icons.arrow_drop_up:Icons.arrow_drop_down_outlined,size: 30,)
                    ],
                  ),
                ),
              Visibility(
                visible: statusTask,
                child:   const Divider(),),
              Visibility(
                visible: statusTask,
                child: SizedBox(
                  height: context.height,
                  child: StreamBuilder(
                    stream: _databaseService.getfind('idProject', widget.idProject) ,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List docDatas=snapshot.data?.docs ??[];
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
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
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                          iconSize: 25,
                                          itemBuilder: (context) =>
                                          [
                                            PopupMenuItem(child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Confirm Complete Task'),
                                                      content: Text.rich(TextSpan(
                                                        text: 'Are you sure you have completed the task',
                                                        children: [
                                                          TextSpan(text: ' ${doc['nameTask']}?',style: const TextStyle(fontWeight: FontWeight.bold))
                                                        ]
                                                      )),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            _databaseService.updateClTask(docId, true);
                                                            Navigator.of(context).pop(); // Đóng hộp thoại
                                                          },
                                                          child: const Text('Yes'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop(); // Đóng hộp thoại mà không xóa
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.done_outline),
                                                  SizedBox(width: 5,),
                                                  Text("Complete the task"),
                                                ],
                                              ),)),
                                            PopupMenuItem(child: InkWell(
                                              onTap: () => Get.to(EmployeeListScreen(role: widget.role,id:docId,idProject:widget.idProject,nameTask:doc['nameTask'],manager:doc["nameManagerTask"]),),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.person),
                                                  SizedBox(width: 5,),
                                                  Text("See the staff"),
                                                ],
                                              ),)),
                                            PopupMenuItem(child:
                                            InkWell(
                                              onTap: () {
                                                  Get.to(EditTaskScreen(
                                                    nameProject:widget.nameTask,
                                                idProject: widget.idProject,
                                                role: widget.role,
                                                id: docId,
                                                task: doc['nameTask'],
                                                manager: doc['nameManagerTask'],
                                                description: doc['description'],
                                                start: doc['dateStart'],
                                                end: doc['dateEnd'],
                                              ));
                                              },
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
                          );
                        },);
                    },
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTaskScreen(role: widget.role, idProject: widget.idProject, nameProject: widget.nameTask,));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _buildBodyStaff() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  statusProject=!statusProject;
                });
              },
              child: Row(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'View project',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Icon(statusProject?Icons.arrow_drop_up:Icons.arrow_drop_down_outlined,size: 30,)
                ],
              ),
            ),
            Visibility(
              visible: statusProject,
              child:   const Divider(),),
            Visibility(
              visible: statusProject,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nameTask,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        'Leader: ${widget.manager}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text.rich(
                            style: const TextStyle(fontSize: 16),
                            TextSpan(
                                children: [
                                  const TextSpan(text: 'Start day:  ',
                                  ),
                                  TextSpan(
                                      text:  DateFormat("MM-dd-yyyy h:mm a").format(widget.start.toDate()),
                                      style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                                  )
                                ]
                            )
                        ),
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text.rich(
                            style: const TextStyle(fontSize: 16),
                            TextSpan(
                                children: [
                                  const TextSpan(text: 'Deadline:  ',
                                  ),
                                  TextSpan(
                                      text:  DateFormat("MM-dd-yyyy h:mm a").format(widget.end.toDate()),
                                      style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                                  )
                                ]
                            )
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )),
            const Divider(),
            InkWell(
                onTap: () {
                  setState(() {
                    statusTask=!statusTask;
                  });
                },
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tasks in the project',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Icon(statusTask?Icons.arrow_drop_up:Icons.arrow_drop_down_outlined,size: 30,)
                  ],
                ),
              ),
            Visibility(
              visible: statusTask,
              child:   const Divider(),),
            Visibility(
              visible: statusTask,
              child: SizedBox(
                height: context.height,
                child: StreamBuilder(
                  stream: _databaseService.getfind('idProject', widget.idProject) ,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List docDatas=snapshot.data?.docs ??[];
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docDatas.length,
                      itemBuilder: (context, index) {
                        var doc = docDatas[index];
                        String docId = doc.id;
                        return StreamBuilder(
                          stream: databaseEmployeesService.getFind('email', "${user!.email}"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const SizedBox.shrink(); // Ẩn widget đi khi không có dữ liệu
                            }
                            // final docEms = snapshot.data?.docs.first;
                            List docEms = snapshot.data?.docs ?? [];
                            return index<docEms.length?
                            Visibility(
                              // visible: docEms[index]['idTask']==docId,
                              child: InkWell(
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
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Task Name:  ${doc['nameTask']}',
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
                            ):
                            SizedBox();
                          },
                        );
                      },);
                  },
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
  Container customProcess(String status,Color color){
    return  Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color,
        ),
        child: Text(status,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
    );
  }
}

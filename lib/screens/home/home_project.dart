import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/screens/project/edit_project/edit_project.dart';
import 'package:quanly_duan/screens/project/view_project/view_project.dart';
import 'package:quanly_duan/service/getX/getX.dart';
import '../login/sign_in/sign_in.dart';
import '../project/add_project/add_project.dart';

class HomeScreenEmployeeProject extends StatefulWidget {
  final String role;

  const HomeScreenEmployeeProject({
    super.key,
    required this.role,
  });

  @override
  State<HomeScreenEmployeeProject> createState() => _HomeScreenEmployeeProject();
}

class _HomeScreenEmployeeProject extends State<HomeScreenEmployeeProject> {
  final DatabaseProjectService databaseProjectService = DatabaseProjectService('db_project');
  final DatabaseService databaseService = DatabaseService('db_task');
  final DatabaseEmployeesService databaseEmployeesService = DatabaseEmployeesService('db_employeesTask');
  final user = FirebaseAuth.instance.currentUser;
  final RoleController roleController=Get.put(RoleController());
  @override
  Widget build(BuildContext context) {
    print(widget.role);
    print(user!.email);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 5, 5, 5)),
        backgroundColor: Colors.blueAccent,
        leading:  GestureDetector(
              onTapDown: (TapDownDetails details) {
              _showPopupMenu(context, details.globalPosition,roleController.name.value);
          },
          child: const Icon(Icons.account_circle,color: Colors.white,size: 40,),
        ),
        actions: [
          widget.role == 'staff'
              ? IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: const Color(0xFFe0efff),
                    context: context,
                    builder: (context) {
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              'My notice',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: context.height * 0.5,
                            child: StreamBuilder(
                              stream: databaseService.getTasks(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List docs = snapshot.data?.docs ?? [];
                                return ListView.builder(
                                  itemCount: docs.length,
                                  itemBuilder: (context, index) {
                                    var doc = docs[index];
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
                                          return const SizedBox.shrink();
                                        }
                                        // final docEms = snapshot.data?.docs.first;
                                        List docEms = snapshot.data?.docs ?? [];
                                       return index<docEms.length?
                                        Visibility(
                                          // visible: docEms[index]['idTask'] ==docId,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            margin: const EdgeInsets.all(10),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.person, color: Colors.black54),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '${doc['nameManagerTask']}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text.rich(
                                                    style: const TextStyle(fontSize: 13),
                                                    TextSpan(
                                                      children: [
                                                        const TextSpan(text: 'The leader has assigned the task '),
                                                        TextSpan(
                                                          text: '${doc['nameTask']}',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        const TextSpan(
                                                          text: ' to you',
                                                          style: TextStyle(fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ):
                                       SizedBox();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
          )
              : const SizedBox(),
        ],
      ),
      body: widget.role == 'staff' ? _buildProjectStaff() : _buildMenuItem(),
    );
  }

  Widget _buildMenuItem() {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: StreamBuilder(
          stream: databaseProjectService.getProjects(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List docs = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                String docId = doc.id;
                return InkWell(
                  onTap: () {
                    Get.to(ViewProject(
                      idProject: docId,
                      role: widget.role,
                      nameTask: doc['nameProject'],
                      manager: doc['projectLeader'],
                      description: doc['description'],
                      start: doc['dateStart'],
                      end: doc['dateEnd'],
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(
                                width: context.width * 0.76,
                                child: Text(
                                  'Name of project:  ${doc['nameProject']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              PopupMenuButton(
                                iconColor: Colors.black54,
                                iconSize: 30,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: InkWell(
                                      onTap: () => Get.to(EditProjectScreen(
                                        role: widget.role,
                                        id: docId,
                                        task: doc['nameProject'],
                                        email: doc['email'],
                                        manager: doc['projectLeader'],
                                        description: doc['description'],
                                        start: doc['dateStart'],
                                        end: doc['dateEnd'],
                                      )),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 5),
                                          Text("Edit Project"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(msg: "Delete success");
                                        databaseProjectService.deleteProject(docId);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 5),
                                          Text("Delete"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text.rich(
                            style: const TextStyle(fontSize: 16),
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Manager: '),
                                TextSpan(
                                  text: '${doc['projectLeader']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text.rich(
                            style: const TextStyle(fontSize: 16),
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Start day:  '),
                                TextSpan(
                                  text: DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateStart"].toDate()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text.rich(
                            style: const TextStyle(fontSize: 16),
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Deadline:  '),
                                TextSpan(
                                  text: DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateEnd"].toDate()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Visibility(
                            // visible: statusTask,
                            child: StreamBuilder(
                              stream: databaseService.getfind('idProject', docId) ,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                // List docDatas=snapshot.data?.docs ??[];
                                // return Text('${1/docDatas.length*100}');
                                List<DocumentSnapshot> docDatas = snapshot.data!.docs;

                                int totalTasks = docDatas.length;
                                int correctTasks = docDatas
                                    .where((doc) => doc['statusTask'] == true)
                                    .length;
                                double percentage = totalTasks == 0
                                    ? 0
                                    : (correctTasks / totalTasks) * 100;
                                return Stack(
                                  children: [
                                    Container(
                                      height: context.height*0.025,
                                      width: context.width ,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    Container(
                                      height: context.height*0.025,
                                      width: context.width*percentage/100,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.blue,
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                    Container(
                                      alignment:Alignment.center,
                                      child: Text('${percentage.toStringAsFixed(2)}%',
                                        style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddProjcetScreen(role: widget.role));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectStaff() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        height: context.height,
        child: StreamBuilder(
          stream: databaseProjectService.getProjects(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List docs = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                String docId = doc.id;
                return StreamBuilder(
                  stream: databaseEmployeesService.getFind('email',"${user!.email}"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    List docEms = snapshot.data?.docs ?? [];
                    // final docEms = snapshot.data?.docs.first;
                    // print(docEms[index]['idProject']);
                    return index<docEms.length?
                    Visibility(
                      // visible:docEms[index]['idProject']==docId,
                      child: InkWell(
                        onTap: () {
                          Get.to(ViewProject(
                            idProject: docId,
                            role: widget.role,
                            nameTask: doc['nameProject'],
                            manager: doc['projectLeader'],
                            description: doc['description'],
                            start: doc['dateStart'],
                            end: doc['dateEnd'],
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: context.width * 0.76,
                                  child: Text(
                                    'Name of project:  ${doc['nameProject']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'Manager: '),
                                      TextSpan(
                                        text: '${doc['projectLeader']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'Start day: '),
                                      TextSpan(
                                        text: DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateStart"].toDate()),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'Deadline: '),
                                      TextSpan(
                                        text: DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateEnd"].toDate()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Visibility(
                                  // visible: statusTask,
                                  child: StreamBuilder(
                                    stream: databaseService.getfind('idProject', docId) ,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      // List docDatas=snapshot.data?.docs ??[];
                                      // return Text('${1/docDatas.length*100}');
                                      List<DocumentSnapshot> docDatas = snapshot.data!.docs;

                                      int totalTasks = docDatas.length;
                                      int correctTasks = docDatas
                                          .where((doc) => doc['statusTask'] == true)
                                          .length;
                                      double percentage = totalTasks == 0
                                          ? 0
                                          : (correctTasks / totalTasks) * 100;
                                      return Stack(
                                        children: [
                                          Container(
                                            height: context.height*0.025,
                                            width: context.width ,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            height: context.height*0.025,
                                            width: context.width*percentage/100,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.blue,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Container(
                                            alignment:Alignment.center,
                                            child: Text('${percentage.toStringAsFixed(2)}%',
                                              style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ):
                    const SizedBox();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
void _showPopupMenu(BuildContext context, Offset position,String name) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
    items: [
      PopupMenuItem(child: InkWell(onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
        // userDataController.updateUserData("","","");
      },
        child:Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 5,),
            Text(name),
            const Divider(),
          ],
        ),)),
        PopupMenuItem(child: InkWell(onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
            // userDataController.updateUserData("","","");
            },
          child: const Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 5,),
              Text("LogOut"),
          ],
        ),)),
  ],
    elevation: 8.0,
  ).then((value) {
    if (value != null) {
      if (value == 'edit') {
        print('Edit option selected');
      } else if (value == 'delete') {
        print('Delete option selected');
      }
    }
  });
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/service/getX/getX.dart';

import '../../../database/database_service.dart';
import '../../project/add_project/add_project.dart';
import '../../project/edit_project/edit_project.dart';
import '../../project/view_project/view_project.dart';
class SearchSreen extends StatefulWidget {
  const SearchSreen({super.key});

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

class _SearchSreenState extends State<SearchSreen> {
  final DatabaseProjectService databaseProjectService=DatabaseProjectService('db_project');
  final DatabaseService databaseService=DatabaseService('db_task');
  final DatabaseEmployeesService databaseEmployeesService=DatabaseEmployeesService('db_employeesTask');
  final user=FirebaseAuth.instance.currentUser;
  final RoleController roleController=Get.put(RoleController());

  String nameSearch='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:roleController.role.value=='staff'?_buildProjectStaff():_buildMenuItem(),
    );
  }
  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20)
          )
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          margin: const EdgeInsets.only(top: 10,bottom: 20,left:20, right: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "search something ....",
              hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
            ),
            onChanged: (value) {
              setState(() {
                nameSearch=value;
              });
            },
          ),
        ),
      ),
    );
  }
  Widget _buildMenuItem() {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: StreamBuilder(
          stream: databaseProjectService.getProjects(),
          // stream: _databaseEmployeesService.getFind('email', "${user!.email}"),
          builder: (context, snapshot) {
            List docs=snapshot.data?.docs ??[];
            List<dynamic>? searchData = docs
                .where((doc) =>
                doc!["nameProject"]
                    .toString()
                    .toLowerCase()
                    .startsWith(nameSearch.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: searchData.length,
              itemBuilder: (context, index) {
                var doc = searchData[index];
                String docId = doc.id;
                return InkWell(
                  onTap: () {
                    Get.to(ViewProject(
                      idProject: docId,
                      role:roleController.role.value,
                      nameTask: doc['nameProject'],
                      manager: doc['projectLeader'],
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
                              SizedBox(
                                width: context.width*0.76,
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
                                itemBuilder: (context) =>
                                [
                                  PopupMenuItem(child:
                                  InkWell(
                                    onTap: () => Get.to(
                                        EditProjectScreen(
                                          role: roleController.role.value,
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
                                        SizedBox(width: 5,),
                                        Text("Edit Task"),
                                      ],
                                    ),)
                                  ),
                                  PopupMenuItem(child: InkWell(onTap: () {
                                    Fluttertoast.showToast(msg: "Delete success");
                                    databaseProjectService.deleteProject(docId);
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
                          // const SizedBox(height: 10),
                          Text.rich(
                              style: const TextStyle(fontSize: 16),
                              TextSpan(
                                  children: [
                                    const TextSpan(text: 'Manager: ',
                                    ),
                                    TextSpan(
                                        text:  '${doc['projectLeader']}',
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
                                        text:  DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateStart"].toDate()),
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
                                        text:  DateFormat("MM-dd-yyyy h:mm a").format(doc?["dateEnd"].toDate()),
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
                );
              },);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(AddProjcetScreen(role: roleController.role.value,));
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
            List docs=snapshot.data?.docs ??[];
            List<dynamic>? searchData = docs
                .where((doc) =>
                doc!["nameProject"]
                    .toString()
                    .toLowerCase()
                    .startsWith(nameSearch.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: searchData.length,
              itemBuilder: (context, index) {
                var doc = searchData[index];
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
                    // final docEms = snapshot.data?.docs.first;
                    List docEms = snapshot.data?.docs ?? [];
                    return index<docEms.length?
                    Visibility(
                      visible: docEms[index]['idProject'] == docId,
                      child: InkWell(
                        onTap: () {
                          Get.to(ViewProject(
                            idProject: docId,
                            role: roleController.role.value,
                            nameTask: doc['nameProject'],
                            manager: doc['projectLeader'],
                            description: doc['description'],
                            start: doc['dateStart'],
                            end: doc['dateEnd'],
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
                                            onTap: () => Get.to(
                                              EditProjectScreen(
                                                role:roleController.role.value,
                                                id: docId,
                                                task: doc['nameProject'],
                                                email: doc['email'],
                                                manager: doc['projectLeader'],
                                                description: doc['description'],
                                                start: doc['dateStart'],
                                                end: doc['dateEnd'],
                                              ),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.edit),
                                                SizedBox(width: 5),
                                                Text("Edit Task"),
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
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(children: [
                                    const TextSpan(text: 'Manager: '),
                                    TextSpan(
                                      text: '${doc['projectLeader']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 19),
                                    )
                                  ]),
                                ),
                                const SizedBox(height: 5),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(children: [
                                    const TextSpan(text: 'Start day: '),
                                    TextSpan(
                                      text: DateFormat("MM-dd-yyyy h:mm a")
                                          .format(doc?["dateStart"].toDate()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 18),
                                    )
                                  ]),
                                ),
                                const SizedBox(height: 5),
                                Text.rich(
                                  style: const TextStyle(fontSize: 16),
                                  TextSpan(children: [
                                    const TextSpan(text: 'Deadline: '),
                                    TextSpan(
                                      text: DateFormat("MM-dd-yyyy h:mm a")
                                          .format(doc?["dateEnd"].toDate()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 18),
                                    )
                                  ]),
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/models/manage.dart';
import 'package:quanly_duan/service/getX/getX.dart';
class ViewTask extends StatefulWidget {
  String role;
  String idTask;
  String nameTask;
  String nameEmployee;
  String manager;
  String description;
  Timestamp start;
  Timestamp end;
  ViewTask({
    super.key,
    required this.idTask,
    required this.nameTask,
    required this.nameEmployee,
    required this.manager,
    required this.description,
    required this.start,
    required this.end,
    required this.role,
  });

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  final DatabaseDailyReportService _dailyReportService=DatabaseDailyReportService('db_dailyReport');
  final DatabaseCommentReportService databaseCommentReportService=DatabaseCommentReportService("db_comment");
  final DatabaseUserService databaseUserService=DatabaseUserService("db_user");
  TextEditingController textEditingControllerDailyReport=TextEditingController();
  TextEditingController textEditingControllerFeedback=TextEditingController();

  TextEditingController textEditingControllerComment=TextEditingController();
  TextEditingController textEditingControllerEditComment=TextEditingController();
  final use=FirebaseAuth.instance.currentUser;
  final RoleController roleController=Get.put(RoleController());
  int _selectedValue=1;
  bool statusTask=false;
  @override
  Widget build(BuildContext context) {
    print(widget.role);
    return Scaffold(
      appBar: _buildAppBar(role:widget.role),
      body: _buildBody(),
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         showModalBottomSheet(
           context: context, 
           builder: (context) {
            return Container(
              width: context.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Daily report",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 const SizedBox(height: 20,),
                  TextField(
                    minLines: 1,
                    maxLines: 20,
                    controller: textEditingControllerDailyReport,
                    decoration: const InputDecoration(
                      hintText: 'Enter daily reports',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      DailyReport dailyData=DailyReport(
                          idTask: widget.idTask,
                          nameTask:widget.nameTask,
                          nameEmployee: widget.nameEmployee,
                          descriptionDailyReport: textEditingControllerDailyReport.text,
                          timeReport: Timestamp.now(),
                          statusReport: 2);
                      _dailyReportService.addData(dailyData);
                      textEditingControllerDailyReport.clear();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Text("Send",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                  )
                ],
              ),
            );    
             },);
       },
       child: const Icon(Icons.add),
     ),
    );
  }
  PreferredSizeWidget _buildAppBar({required String role}) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Center(child: Text("View Task",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
      leading: InkWell(
        // onTap: () =>role=='admin'||role=='manager'? Get.offAll(HomeScreen(role: role,)):Get.offAll(const HomeScreenEmployee(role: 'staff',)),
          onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back,color: Colors.white,),
      ),
      actions: const [
        Icon(Icons.confirmation_num_sharp,color: Colors.blue,)
      ],
    );
  }
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.nameTask,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              'Manager: ${widget.manager}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 20,
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
            const Divider(),
            InkWell(
              onTap: () {
                setState(() {
                  statusTask=!statusTask;
                });
              },
              child: Row(
                children: [
                  const Text(
                    'Daily report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(statusTask?Icons.arrow_drop_up:Icons.arrow_drop_down_outlined,size: 30,)
                ],
              ),
            ),
            const Divider(),
            Visibility(
              visible: statusTask,
              child: SizedBox(
                height: context.height,
                child: StreamBuilder(
                    stream: _dailyReportService.getFind('idTask', widget.idTask),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List docs=snapshot.data?.docs ??[];
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var doc = docs[index];
                          String docId = doc.id;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(DateFormat("MM-dd-yyyy h:mm a").format(doc?["timeReport"].toDate()),
                                    style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 14)),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person),
                                  Text(
                                    ' ${doc['nameEmployee']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: doc['descriptionDailyReport'].toString().length>28?context.width*0.7:null,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:10.0),
                                      child: Text('${doc['descriptionDailyReport']}',
                                          style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: roleController.name.value==doc['nameEmployee'] && roleController.role.value=='staff',
                                    child: PopupMenuButton(
                                      iconColor: Colors.black54,
                                      iconSize: 30,
                                      color: Colors.white,
                                      itemBuilder: (context) =>
                                      [
                                        PopupMenuItem(child:
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  width: context.width,
                                                  padding: const EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      const Text("Edit Daily reports",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                      const SizedBox(height: 20,),
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))
                                                        ),
                                                        child: TextField(
                                                          minLines: 1,
                                                          maxLines: 20,
                                                          controller: textEditingControllerDailyReport,
                                                          decoration: InputDecoration(
                                                              hintText: doc['descriptionDailyReport'],
                                                              border: const OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 1),
                                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          DailyReport dailyData=DailyReport(
                                                              idTask:doc['idTask'],
                                                              nameTask:doc['nameTask'],
                                                              nameEmployee: doc['nameEmployee'],
                                                              descriptionDailyReport:textEditingControllerDailyReport.text==''?doc['descriptionDailyReport']:textEditingControllerDailyReport.text,
                                                              timeReport: Timestamp.now(),
                                                              statusReport: _selectedValue);
                                                          _dailyReportService.updateData(docId,dailyData);
                                                          textEditingControllerDailyReport.clear();
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.all(10),
                                                          margin: const EdgeInsets.symmetric(vertical: 20),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          ),
                                                          child: const Text("Send",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 5,),
                                              Text("Edit Task"),
                                            ],
                                          ),)
                                        ),
                                        PopupMenuItem(child: InkWell(
                                          onTap: () {
                                            _dailyReportService.deleteData(docId);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.delete),
                                              SizedBox(width: 5,),
                                              Text("Delete"),
                                            ],
                                          ),)),
                                      ],)
                                  ),
                                  Visibility(visible: widget.role=='manager'|| widget.role=='admin',child:  PopupMenuButton(
                                    iconColor: Colors.black54,
                                    iconSize: 30,
                                    color: Colors.white,
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(child:
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return StreamBuilder(
                                                stream: databaseUserService.getFind('email',"${use!.email}"),
                                                builder:(context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  final docUsers=snapshot.data?.docs.first;
                                                  final docUserId=docUsers?.id;
                                                  return Container(
                                                    width: context.width,
                                                    padding: const EdgeInsets.all(20),
                                                    child: Column(
                                                      children: [
                                                        const Text("Comment on the reports",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                        const SizedBox(height: 20,),
                                                        Container(
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          ),
                                                          child: TextField(
                                                            controller: textEditingControllerFeedback,
                                                            minLines: 1,
                                                            maxLines: 30,
                                                            decoration: const InputDecoration(
                                                              hintText: "Comment on the report",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                  width: 1,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Comment comment=Comment(
                                                                idTask:doc['idTask'],
                                                                idUser:"$docUserId",
                                                                idReport: docId,
                                                                nameUser: "${docUsers!['displayName']}",
                                                                description:textEditingControllerFeedback.text,
                                                                time: Timestamp.now()
                                                            );
                                                            databaseCommentReportService.addData(comment);
                                                            Navigator.pop(context);
                                                            textEditingControllerFeedback.clear();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.all(10),
                                                            margin: const EdgeInsets.symmetric(vertical: 20),
                                                            decoration: const BoxDecoration(
                                                              color: Colors.blue,
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            ),
                                                            child: const Text("Send",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },);
                                            },);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.messenger),
                                            SizedBox(width: 5,),
                                            Text("Feedback"),
                                          ],
                                        ),)
                                      ),
                                      PopupMenuItem(child:
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                width: context.width,
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    const Text("Edit Daily reports",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                    const SizedBox(height: 20,),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      child: TextField(
                                                        minLines: 1,
                                                        maxLines: 20,
                                                        controller: textEditingControllerDailyReport,
                                                        decoration: InputDecoration(
                                                            hintText: doc['descriptionDailyReport'],
                                                            border: const OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1),
                                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        DailyReport dailyData=DailyReport(
                                                            idTask:doc['idTask'],
                                                            nameTask:doc['nameTask'],
                                                            nameEmployee: doc['nameEmployee'],
                                                            descriptionDailyReport:textEditingControllerDailyReport.text==''?doc['descriptionDailyReport']:textEditingControllerDailyReport.text,
                                                            timeReport: Timestamp.now(),
                                                            statusReport: _selectedValue);
                                                        _dailyReportService.updateData(docId,dailyData);
                                                        textEditingControllerDailyReport.clear();
                                                      },
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.all(10),
                                                        margin: const EdgeInsets.symmetric(vertical: 20),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        child: const Text("Send",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 5,),
                                            Text("Edit Task"),
                                          ],
                                        ),)
                                      ),
                                      PopupMenuItem(child: InkWell(
                                        onTap: () {
                                          _dailyReportService.deleteData(docId);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 5,),
                                            Text("Delete"),
                                          ],
                                        ),)),
                                    ],))
                                ],
                              ),
                                StreamBuilder(
                                    stream: databaseCommentReportService.getFind("idReport", docId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      // final docComments=snapshot.data?.docs.first;
                                      // final docCommentId=docComments?.id;
                                      final List<DocumentSnapshot> commentDocs = snapshot.data!.docs;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: commentDocs.map((commentDoc) {
                                          final commentId = commentDoc.id;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:30.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.person),
                                                    const SizedBox(width: 10,),
                                                    Text(commentDoc["nameUser"],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      // elevation: 5,
                                                      width: commentDoc['description'].toString().length>28?context.width*0.75:null,
                                                      margin: const EdgeInsets.all(10),
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                                                        child: Text('${commentDoc['description']}',
                                                            style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                                                      ),
                                                    ),
                                                    widget.role=='staff'? const SizedBox():
                                                    PopupMenuButton(
                                                      iconColor: Colors.black54,
                                                      iconSize: 30,
                                                      color: Colors.white,
                                                      itemBuilder: (context) =>
                                                      [
                                                        PopupMenuItem(child:
                                                        InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder: (context) {
                                                                return Container(
                                                                  width: context.width,
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: Column(
                                                                    children: [
                                                                      const Text("Edit Comment",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                                      const SizedBox(height: 20,),
                                                                      Container(
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))
                                                                        ),
                                                                        child: TextField(
                                                                          minLines: 1,
                                                                          maxLines: 20,
                                                                          controller: textEditingControllerEditComment,
                                                                          decoration: InputDecoration(
                                                                              hintText: commentDoc['description'],
                                                                              border: const OutlineInputBorder(
                                                                                  borderSide: BorderSide(width: 1),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                                                              )
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          databaseCommentReportService.updateComment(commentId,textEditingControllerEditComment.text );
                                                                          Navigator.pop(context);
                                                                          textEditingControllerEditComment.clear();
                                                                        },
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          padding: const EdgeInsets.all(10),
                                                                          margin: const EdgeInsets.symmetric(vertical: 20),
                                                                          decoration: const BoxDecoration(
                                                                            color: Colors.blue,
                                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                          ),
                                                                          child: const Text("Send",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },);
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(Icons.edit),
                                                              SizedBox(width: 5,),
                                                              Text("Edit Task"),
                                                            ],
                                                          ),)
                                                        ),
                                                        PopupMenuItem(
                                                            child: InkWell(
                                                              onTap: () {
                                                               databaseCommentReportService.deleteData(commentId);
                                                              },
                                                              child: const Row(
                                                                children: [
                                                                  Icon(Icons.delete),
                                                                  SizedBox(width: 5,),
                                                                  Text("Delete"),
                                                                ],
                                                              ),)),
                                                      ],),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },),
                            ],
                          );
                        },);
                    },),
              ),
            )
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

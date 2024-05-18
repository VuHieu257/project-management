import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:quanly_duan/models/manage.dart';
import 'package:quanly_duan/service/getX/getX.dart';

import '../../../service/auth_service.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>{
  final DatabaseUserService databaseUserService=DatabaseUserService('db_user');
  final DatabaseWelfareService databaseWelfareService=DatabaseWelfareService('db_welfare');
  final DatabaseRegisterWelfareService databaseRegisterWelfareService=DatabaseRegisterWelfareService('db_registerWelfare');
  final email=FirebaseAuth.instance.currentUser!.email;
  final RoleController roleController=Get.put(RoleController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              _buildMenuItem(),
              _buildMenuApproval(),
            ],
          ),
            floatingActionButton:roleController.role.value=='admin'?FloatingActionButton(
              onPressed: () {
                Get.to(const AddBefenit());
              },
              child: const Icon(Icons.add),
          ):const SizedBox(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 5, 5, 5)),
      backgroundColor: Colors.blue,
      elevation: 0,
      title: Center(child: const Text("Walfare",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
      bottom:const TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab (child: Text("See all benefits",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),),
          Tab (child: Text("Approval benefits",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),),
        ],
      ),
    );
  }
  Widget _buildMenuItem() {
    return StreamBuilder(
      stream: databaseWelfareService.gets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
            return const Center(child: Text('No data Welfare'));
          }
          List docs=snapshot.data?.docs ??[];
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              String docId = doc.id;
              return InkWell(
                onTap: () {
                  Get.to(ViewBefenitScreen(
                    id: docId,
                    name: doc['nameWelfare'],
                    description: doc['description'],
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
                        Row(
                          children: [
                            SizedBox(
                              width: context.width * 0.76,
                              child: Text(
                                '${doc['nameWelfare']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: roleController.role.value=='admin',
                              child: PopupMenuButton(
                                iconColor: Colors.black54,
                                iconSize: 30,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: InkWell(
                                      onTap: () =>Get.to(EditBefenitScreen(
                                        id: docId,
                                        description: doc['description'],
                                        name: doc['nameWelfare'],
                                      )),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 5),
                                          Text("Edit Welfare"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(msg: "Delete success");
                                        databaseWelfareService.deleteData(docId);
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
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:10.0),
                          child: Text('${doc['description']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 19),textAlign: TextAlign.justify,overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
  Widget _buildMenuApproval() {
    return StreamBuilder(
      stream: databaseRegisterWelfareService.gets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
            return const Center(child: Text('No data Welfare'));
          }
          List docRegisters=snapshot.data?.docs ??[];
          return ListView.builder(
            itemCount: docRegisters.length,
            itemBuilder: (context, index) {
              var docRe = docRegisters[index];
              String docId = docRe.id;
              print(docRe['emailUser']);
              return roleController.role.value=='staff'?
              Visibility(
                visible: docRe['emailUser']=='$email',
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
                            'Welfare: ${docRe['nameWelfare']} ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder(stream: databaseUserService.getFind('email',"${docRe['emailUser']}" ),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(child: Text('Something went wrong'));
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                                return const Center(child: Text('No data Welfare'));
                              }
                              // final docUser=snapshot.data?.docs.first;
                              List docUser=snapshot.data?.docs??[];
                              return SizedBox(
                                height: context.height*0.04,
                                child: ListView.builder(
                                  itemCount: docUser.length,
                                  itemBuilder: (context, index) {
                                    final docUse=docUser[index];
                                  return SizedBox(
                                    width: context.width * 0.76,
                                    child: Text(
                                      'Staff: ${docUse['displayName']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },),
                              );
                            },),
                        Visibility(
                            visible: docRe['statusRegister']==0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all( Radius.circular(15)),
                                color: Colors.green.shade300,
                              ),
                              child: const Text("Has been approved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )),
                        Visibility(
                            visible: docRe['statusRegister']==1 && roleController.role.value=='staff',
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all( Radius.circular(15)),
                                color: Colors.orange.shade300,
                              ),
                              child: const Text("Process",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )),
                        Visibility(
                            visible: docRe['statusRegister']==2,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all( Radius.circular(15)),
                                color: Colors.red.shade300,
                              ),
                              child: const Text("not approved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )),
                        Row(
                          children: [
                            Visibility(
                              visible: docRe['statusRegister']==1 && roleController.role.value!='staff',
                                child: InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: 'approve success');
                                    databaseRegisterWelfareService.updateWelfare(docId, 0);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all( Radius.circular(15)),
                                      color: Colors.blue,
                                    ),
                                    child: const Text("Approve",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                                            ),
                                )),
                            Visibility(
                                visible: docRe['statusRegister']==1 && roleController.role.value!='staff',
                                child: InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: 'Unapproved success');
                                    databaseRegisterWelfareService.updateWelfare(docId, 2);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all( Radius.circular(15)),
                                      color: Colors.blue,
                                    ),
                                    child: const Text("Unapproved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ):
              Container(
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
                          'Welfare: ${docRe['nameWelfare']} ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder(stream: databaseUserService.getFind('email',"${docRe['emailUser']}" ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something went wrong'));
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                            return const Center(child: Text('No data Welfare'));
                          }
                          // final docUser=snapshot.data?.docs.first;
                          List docUser=snapshot.data?.docs??[];
                          return SizedBox(
                            height: context.height*0.035,
                            child: ListView.builder(
                              itemCount: docUser.length,
                              itemBuilder: (context, index) {
                                final docUse=docUser[index];
                                return SizedBox(
                                  width: context.width * 0.76,
                                  child: Text(
                                    'Staff: ${docUse['displayName']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },),
                          );
                        },),
                      Visibility(
                          visible: docRe['statusRegister']==0,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all( Radius.circular(15)),
                              color: Colors.green.shade300,
                            ),
                            child: const Text("Has been approved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          )),
                      Visibility(
                          visible: docRe['statusRegister']==1 && roleController.role.value=='staff',
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all( Radius.circular(15)),
                              color: Colors.orange.shade300,
                            ),
                            child: const Text("Process",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          )),
                      Visibility(
                          visible: docRe['statusRegister']==2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all( Radius.circular(15)),
                              color: Colors.red.shade300,
                            ),
                            child: const Text("not approved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          )),
                      Row(
                        children: [
                          Visibility(
                              visible: docRe['statusRegister']==1 && roleController.role.value!='staff',
                              child: InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(msg: 'approve success');
                                  databaseRegisterWelfareService.updateWelfare(docId, 0);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all( Radius.circular(15)),
                                    color: Colors.blue,
                                  ),
                                  child: const Text("Approve",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ),
                              )),
                          Visibility(
                              visible: docRe['statusRegister']==1 && roleController.role.value!='staff',
                              child: InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(msg: 'Unapproved success');
                                  databaseRegisterWelfareService.updateWelfare(docId, 2);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all( Radius.circular(15)),
                                    color: Colors.blue,
                                  ),
                                  child: const Text("Unapproved",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },);
        },);
  }
}

class AddBefenit extends StatefulWidget {
  const AddBefenit({super.key});

  @override
  _AddBefenitState createState() => _AddBefenitState();
}

class _AddBefenitState extends State<AddBefenit> {
  TextEditingController textEditingControllerNameWelfare=TextEditingController();
  TextEditingController textEditingControllerDescription=TextEditingController();
  DatabaseWelfareService databaseWelfareService=DatabaseWelfareService('db_welfare');
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create welfare',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFFe0efff),
        leading: InkWell(
          onTap: () {
            Get.offAll(BottomNavigationBarWidget());
          },
          child:Icon(Icons.arrow_back),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: textEditingControllerNameWelfare,
                validator: (value) => value!.isEmpty?'Enter data':null,
                decoration: InputDecoration(
                  labelText: 'Name Welfare',
                  hintText: 'Endter name welfare',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => value!.isEmpty?'Enter data':null,
                minLines: 1,
                maxLines: 18,
                controller: textEditingControllerDescription,
                decoration: InputDecoration(
                  labelText: 'Description Welfare',
                  hintText: 'Endter description welfare',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                      maxHeight: MediaQuery.of(context).size.height * 10.5),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  if(_formkey.currentState!.validate()){
                    Welfare welfare=Welfare(
                        nameWelfare: textEditingControllerNameWelfare.text,
                        description: textEditingControllerDescription.text,
                        time: Timestamp.now());
                    Get.offAll(const AdminScreen());
                    databaseWelfareService.addData(welfare);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.blue,
                  ),
                  child: const Text("Create Welfare",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewBefenitScreen extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  const ViewBefenitScreen({super.key,required this.id, required this.name, required this.description});

  @override
  _ViewBefenitScreenState createState() => _ViewBefenitScreenState();
}

class _ViewBefenitScreenState extends State<ViewBefenitScreen> {
  final DatabaseRegisterWelfareService databaseRegisterWelfareService=DatabaseRegisterWelfareService('db_registerWelfare');
  final email=FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(child:  Text('Detail Welfare',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () => Get.offAll(const BottomNavigationBarWidget()), icon: const Icon(Icons.arrow_back, color: Colors.white,)),
        actions: const [
          Icon(Icons.add,color: Colors.blue,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,),),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          RegisterWelfare registerWelfare=RegisterWelfare
            (idWelfare: widget.id, emailUser: "$email", statusRegister: 1, nameWelfare: widget.name);
          Get.offAll(const BottomNavigationBarWidget());
          databaseRegisterWelfareService.addData(registerWelfare);
        },
        child: Container(
          height: context.height*0.07,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: const Text(
            "Register welfare",
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class EditBefenitScreen extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  const EditBefenitScreen({super.key,required this.id,required this.name,required this.description,});

  @override
  _EditBefenitScreenState createState() => _EditBefenitScreenState();
}

class _EditBefenitScreenState extends State<EditBefenitScreen> {
  TextEditingController textEditingControllerNameWelfare=TextEditingController();
  TextEditingController textEditingControllerDescription=TextEditingController();
  DatabaseWelfareService databaseWelfareService=DatabaseWelfareService('db_welfare');
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    textEditingControllerNameWelfare.text=widget.name;
    textEditingControllerDescription.text=widget.description;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(child:  Text('Edit Welfare',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () => Get.offAll(const BottomNavigationBarWidget()), icon: const Icon(Icons.arrow_back, color: Colors.white,)),
        actions: const [
          Icon(Icons.add,color: Colors.blue,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: TextField(
                controller: textEditingControllerNameWelfare,
                decoration: InputDecoration(
                  labelText: 'Name Welfare',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: TextField(
                controller: textEditingControllerDescription,
                minLines: 1,
                maxLines: 19,
                decoration: InputDecoration(
                  labelText: 'Descripton',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                      maxHeight: MediaQuery.of(context).size.height * 10.5),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Welfare welfare=Welfare(nameWelfare: textEditingControllerNameWelfare.text, description: textEditingControllerDescription.text, time: Timestamp.now());
          Get.offAll(const AdminScreen());
          Fluttertoast.showToast(msg: "success");
          databaseWelfareService.updateData(widget.id,welfare);
        },
        child: Container(
          height: context.height*0.07,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: const Text(
            "Save",
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
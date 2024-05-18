import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanly_duan/database/database_service.dart';
import 'package:quanly_duan/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:quanly_duan/models/manage.dart';
import 'package:quanly_duan/service/getX/getX.dart';
class AddTaskScreen extends StatefulWidget {
  final String role;
  final String idProject;
  final String nameProject;
  const AddTaskScreen({
    super.key,
    required this.role,
    required this.idProject,
    required this.nameProject,
  });


  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}
class _AddTaskScreenState extends State<AddTaskScreen> {
  final DatabaseService _databaseService=DatabaseService("db_task");
  TextEditingController textEditingControllerTaskName=TextEditingController();
  TextEditingController textEditingControllerTaskDescription=TextEditingController();
  final RoleController roleController=Get.put(RoleController());
  Timestamp selectedTimestamp = Timestamp.now();
  Timestamp selectedDeadlineTimestamp = Timestamp.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedTimestamp.toDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedTimestamp = Timestamp.fromDate(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedTimestamp.toDate().hour,
          selectedTimestamp.toDate().minute,
        ));
      });
    }
  }
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTimestamp.toDate()),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTimestamp = Timestamp.fromDate(DateTime(
          selectedTimestamp.toDate().year,
          selectedTimestamp.toDate().month,
          selectedTimestamp.toDate().day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      });
    }
  }
  Future<void> selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadlineTimestamp.toDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDeadlineTimestamp = Timestamp.fromDate(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDeadlineTimestamp.toDate().hour,
          selectedDeadlineTimestamp.toDate().minute,
        ));
      });
    }
  }
  Future<void> selectTimeDeadline(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDeadlineTimestamp.toDate()),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDeadlineTimestamp = Timestamp.fromDate(DateTime(
          selectedDeadlineTimestamp.toDate().year,
          selectedDeadlineTimestamp.toDate().month,
          selectedDeadlineTimestamp.toDate().day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text("Create task",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
        leading: InkWell(
          // onTap: () =>role=='admin'||role=='manager'? Get.offAll(HomeScreen(role: role,)):Get.offAll(const HomeScreenEmployee(role: 'staff',)),
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        actions: const [
          Icon(Icons.confirmation_num_sharp,color: Colors.blue,)
        ],
      ),
      body: IntrinsicHeight(
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                customTextField("Enter a Task Name","Task Name",textEditingControllerTaskName),
                const SizedBox(height: 10,),
                customTextField("Enter a Task description","Task Description",textEditingControllerTaskDescription),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 10,),
                      const Text("Start day",  style: TextStyle(fontSize: 18),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => selectDate(context),
                        child:Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(selectedTimestamp.toDate()),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 10,),
                      const Text("Deadline",  style: TextStyle(fontSize: 18),),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => selectDeadline(context),
                        child:Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(selectedDeadlineTimestamp.toDate()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Task task=Task(
                        idProject: widget.idProject,
                        nameProject: widget.nameProject,
                        nameTask: textEditingControllerTaskName.text,
                        nameManagerTask:roleController.name.value,
                        description: textEditingControllerTaskDescription.text,
                        statusTask: false,
                        dateStart: selectedTimestamp,
                        dateEnd: selectedDeadlineTimestamp);
                    _databaseService.addTask(task);
                    Get.offAll(const BottomNavigationBarWidget());
                    textEditingControllerTaskName.clear();
                    textEditingControllerTaskDescription.clear();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Text("Create task",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  TextField customTextField(String hintText,String labelText,TextEditingController controller){
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 30,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1),
        ),
        label: Text(labelText),
      ),
    );
  }
}

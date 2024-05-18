import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/screens/home/home_employee/home-employee.dart';
import 'package:quanly_duan/screens/login/sign_in/sign_in.dart';
import 'package:quanly_duan/screens/login/sign_up/sign_up_staff.dart';
import 'package:quanly_duan/screens/profile/profile.dart';
import 'package:quanly_duan/screens/task/add_task/add_task.dart';

import '../../screens/home/home_welfare_manager/home.dart';
import '../../service/getX/getX.dart';

class CustomDrawer extends StatefulWidget {
  final String role;
  const CustomDrawer({super.key, required this.role});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final RoleController _roleController=Get.put(RoleController());

  @override
  Widget build(BuildContext context) {
    print(_roleController.role.value);
    return
      _roleController.role.value=='admin'||_roleController.role.value=='manager'?
    Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Logo',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.offAll(HomeScreen(role:_roleController.role.value,));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Get.to(const ProfilePage());
            },
          ),
          ListTile(
            title: const Text('Add task'),
            onTap: () {
              // Get.offAll(AddTaskScreen(role: widget.role,));
            },
          ),
          ListTile(
            title: const Text('Task list has been completed'),
            onTap: () {
              // Add logic for task screen
            },
          ),
          ListTile(
            title: const Text('Create employee accounts'),
            onTap: () {
              Get.offAll(const SignUpScreen()) ;
            },
          ),
          ListTile(
            title: const Text('Welfare'),
            onTap: () {
              // Add logic for Benefit Screen
            },
          ),
          ListTile(
            title: const Text('Benefit approval'),
            onTap: () {
              // Add logic for Approve Benefit Screen
            },
          ),
          ListTile(
            title: const Text('LogOut'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(const SignInScreen());
            },
          ),
        ],
      ),
    ):
    Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Logo',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.offAll(const HomeScreenEmployee(role:'staff'));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Get.to(const ProfilePage());
            },
          ),
          ListTile(
            title: const Text('Task list has been completed'),
            onTap: () {
              // Add logic for task screen
            },
          ),
          ListTile(
            title: const Text('Welfare'),
            onTap: () {
              // Add logic for Benefit Screen
            },
          ),
          ListTile(
            title: const Text('LogOut'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(const SignInScreen());
            },
          ),
        ],
      ),
    );
  }
}

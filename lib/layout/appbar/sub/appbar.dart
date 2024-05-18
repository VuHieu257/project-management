import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/service/getX/getX.dart';

class CustomAppBarSub extends StatefulWidget implements PreferredSizeWidget {
  final String textAppBar;
  final String role;
  const CustomAppBarSub({Key? key, required this.textAppBar, required this.role}) : super(key: key);

  @override
  _CustomAppBarSubState createState() => _CustomAppBarSubState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarSubState extends State<CustomAppBarSub> {
  final RoleController _roleController = Get.put(RoleController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Center(
        child: Text(
          widget.textAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
      leading:
      InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: const [
        Icon(Icons.confirmation_num_sharp, color: Colors.blue),
      ],
    );
  }
}

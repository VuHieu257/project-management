import 'package:flutter/material.dart';

import '../appbar/main/appbar_main.dart';
import '../appbar/builddrawer.dart';
import '../bottom_navigation_bar/bottom_navigation_bar.dart';


class AppLayout extends StatelessWidget {
  final Widget content;
  final String role;
  const AppLayout({Key? key, required this.content, required this.role}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(role:role),
      body: content,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly_duan/screens/profile/profile.dart';
import 'package:quanly_duan/service/getX/getX.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../screens/home/admin/admin_screen.dart';
import '../../screens/home/home_project.dart';
import '../../screens/home/search/search.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    super.key,
  });

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final RoleController roleController=Get.put(RoleController());
  // final List<Widget> _pages = [
  //   HomeScreenEmployeeProject(role:'${roleController.role.value}'),
  //   LikesPage(),
  //   SearchPage(),
  //   const ProfilePage(),
  // ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, -1),
              color: Colors.blue.shade200,
              blurRadius: 15
            )
          ]
        ),
        child: SalomonBottomBar(
          margin: const EdgeInsets.all(15),
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),
            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: const Text("Search"),
              selectedColor: Colors.orange,
            ),
        
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text("Welfares"),
              selectedColor: Colors.pink,
            ),
        
            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeScreenEmployeeProject(role:roleController.role.value,);
      case 1:
        return const SearchSreen() ;
      case 2:
        return const AdminScreen();
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }
}
class LikesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Likes Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Search Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


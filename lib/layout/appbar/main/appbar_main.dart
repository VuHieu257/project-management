import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 5, 5, 5)),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_alert,color: Colors.white,),
          onPressed: () {
            // Handle icon button press
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class AcpbefenitScreen extends StatefulWidget {
  const AcpbefenitScreen({super.key});

  @override
  _AcpbefenitScreenState createState() => _AcpbefenitScreenState();
}

class _AcpbefenitScreenState extends State<AcpbefenitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildMenuItem(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 5, 5, 5)),
      backgroundColor: const Color(0xFFF7F7F7),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box),
          onPressed: () {
            // Xử lý khi biểu tượng được nhấn
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem() {
    return IntrinsicHeight(
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(255, 255, 255, 255),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'yều cầu: thêm tiền thuê server',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
              SizedBox(height: 5),
              Text(
                'tên người yêu cầu: Trần quốc hut',
                style: TextStyle(fontSize: 16),
              ),
              
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ViewAcpbefenitScreen()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 83, 237, 243)),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 8, 0, 0)),
                      // Nút có kích thước 1/2.2 chiều rộng màn hình và cao 40
                    ),
                    child: Text('Phê duyện'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ViewAcpbefenitScreen()));
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     String? link;
                      //     return AlertDialog(
                      //       title: Text('Nhập nhận xét'),
                      //       content: TextField(
                      //         onChanged: (value) {
                      //           link = value;
                      //         },
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () {
                      //             // Send the link to the server
                      //             //...
                      //             Navigator.pop(context);
                      //           },
                      //           child: Text('Gửi'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 83, 237, 243)),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 8, 0, 0)),
                      // Nút có kích thước 1/2.2 chiều rộng màn hình và cao 40
                    ),
                    child: Text('từ chối yêu cầu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ListbefenitScreen extends StatefulWidget {
  @override
  _ListbefenitScreenState createState() => _ListbefenitScreenState();
}

class _ListbefenitScreenState extends State<ListbefenitScreen> {
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
          icon: Icon(Icons.add_box),
          onPressed: () {
            // Xử lý khi biểu tượng được nhấn
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClaimBenefitsScreen()),
              );
            
          },
        ),
      ],
    );
  }



  Widget _buildMenuItem() {
    return const IntrinsicHeight(
      child: Card(
        elevation: 5,
        color: Color.fromARGB(255, 255, 255, 255),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'tên phúc lợi: cho tiền thuê server',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
              SizedBox(height: 5),
              Text(
                'Thời hạn phúc lợi: 5tr/tháng',
                style: TextStyle(fontSize: 16),
              ),
              
              SizedBox(height: 15),
              
            ],
          ),
        ),
      ),
    );
  }
}
class AddClaimBenefitsScreen extends StatefulWidget {
  @override
  _AddClaimBenefitsState createState() => _AddClaimBenefitsState();
}
class _AddClaimBenefitsState extends State<AddClaimBenefitsScreen> {
  String _name = '';
  String _position = '';
  String _role = 'Nhân viên';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yêu cầu phúc lợi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên phúc lời:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(labelText: 'Tên phúc lời'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 15),
             Text('Lý do:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(labelText: 'để làm gì đó đã đủ điều kiện'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Add your logic to add the employee to the project
                // You can use _name, _position, and _role variables here
                Navigator.pop(context);
              },
              child: Text('Gửi yêu cầu'),
            ),
          ],
        ),
      ),
    );
  }
}
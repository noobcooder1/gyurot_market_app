import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.notifications)),
            title: Text('새로운 이벤트가 있습니다!'),
            subtitle: Text('지금 바로 확인해보세요.'),
            trailing: Text('1분 전'),
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.chat)),
            title: Text('당근이 흔들려요!'),
            subtitle: Text('새로운 채팅이 도착했습니다.'),
            trailing: Text('10분 전'),
          ),
        ],
      ),
    );
  }
}

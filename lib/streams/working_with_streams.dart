import 'dart:async';

import 'package:flutter/material.dart';

class WorkingWithStreams extends StatefulWidget {
  const WorkingWithStreams({Key? key}) : super(key: key);

  @override
  State<WorkingWithStreams> createState() => _WorkingWithStreamsState();
}

class _WorkingWithStreamsState extends State<WorkingWithStreams> {
  StreamController<UserData> streamController = StreamController<UserData>.broadcast();
  late StreamSubscription streamSubscription;

  String text = "";
  late Stream<UserData> stream = createNewUser(UserData(age: 10, userName: "Test User"));

  @override
  void initState() {
    forwardDataToStream();
    streamSubscription = streamController.stream.listen((event) {
      setState(() {
        stream = createNewUser(event);
      });
    });
    super.initState();
  }

  forwardDataToStream() async {
    await Future.delayed(const Duration(seconds: 2));
    streamController.sink.add(UserData(age: 1, userName: "Abdulloh"));
    await Future.delayed(const Duration(seconds: 3));
    streamController.add(UserData(age: 2, userName: "Falochi"));
    await Future.delayed(const Duration(seconds: 5));
    streamController.sink.add(UserData(age: 212, userName: "Kimdur"));
  }

  //1- usul
  Stream<UserData> createNewStream(int userCount) async* {
    yield UserData(age: userCount, userName: "Ibrohim");
    await Future.delayed(const Duration(seconds: 3));
    yield UserData(age: userCount, userName: "Shukrullo");
    await Future.delayed(const Duration(seconds: 5));
    yield UserData(age: userCount, userName: "Shoptoli");
  }

  Stream<UserData> createNewUser(UserData userData) async* {
    yield userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Working with streams"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<UserData>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return Text(
                    "User name:${user.userName}, Age:${user.age}",
                    style: const TextStyle(fontSize: 32),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  streamSubscription.pause();
                  print(streamSubscription.isPaused);
                  print(streamController.isPaused);
                  // streamController.addStream(createNewStream(10));
                  //forwardDataToStream();
                  // streamController.addError("ERRROR");
                },
                child: Text("Send Data"))
          ],
        ),
      ),
    );
  }
}

class UserData {
  UserData({required this.age, required this.userName});

  final String userName;
  final int age;
}

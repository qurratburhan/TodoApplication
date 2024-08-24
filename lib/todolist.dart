import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/service/Database.dart';
import 'package:random_string/random_string.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool today = true, tomorrow = false, nextweek = false;
  TextEditingController todocontroller = TextEditingController();
  Stream? todoStream;

  getontheload() async {
    todoStream = await DatabaseMethods().getallthework(
      today ? "Today" : tomorrow ? "Tomorrow" : "NextWeek",
    );
    setState(() {});
  }

  Widget allWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ListTile(
                    leading: Checkbox(
                      activeColor: Colors.lightBlue,
                      value: ds["Yes"],
                      onChanged: (newValue) async {
                        await DatabaseMethods().updateifTicked(
                          ds["id"],
                          today ? "Today" : tomorrow ? "Tomorrow" : "NextWeek",
                        );
                        setState(() {});
                      },
                    ),
                    title: Text(
                      ds["Work"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Update Button
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: const Color.fromARGB(255, 91, 201, 207)),
                          onPressed: () {
                            showUpdateDialog(ds);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.blue),
                          onPressed: () async {
                            await DatabaseMethods().deleteTask(
                              ds["id"],
                              today ? "Today" : tomorrow ? "Tomorrow" : "NextWeek",
                            );
                            setState(() {
                              getontheload(); // Refresh the list after deletion
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  void showUpdateDialog(DocumentSnapshot ds) {
    todocontroller.text = ds["Work"];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Task"),
        content: TextField(
          controller: todocontroller,
          decoration: InputDecoration(hintText: "Enter new task description"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseMethods().updateTask(
                ds["id"],
                todocontroller.text,
                today? "Today" : tomorrow ? "Tomorrow" : "NextWeek",
              );
              Navigator.pop(context);
              getontheload(); // Refresh the list after update
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getontheload(); // Load data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.lightBlue,
          size: 30.0,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50.0, left: 28.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232FDA2), Color(0xFF13D8CA), Color(0xFF09aDFE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HELLO\n ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Welcome Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        today = true;
                        tomorrow = false;
                        nextweek = false;
                        getontheload();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: today ? Color(0xFF3dffe3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 7.0),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        today = false;
                        tomorrow = true;
                        nextweek = false;
                        getontheload();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            tomorrow ? Color(0xFF3dffe3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Tomorrow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 7.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        today = false;
                        tomorrow = false;
                        nextweek = true;
                        getontheload();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: nextweek ? Color(0xFF3dffe3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Next Week',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            allWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 30.0),
                      Text(
                        "Add Task",
                        style: TextStyle(
                          color: Color(0xff008080),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: todocontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Text ",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> usertodo = {
                        "Work": todocontroller.text,
                        "id": id,
                        "Yes": false,
                      };
                      today
                          ? DatabaseMethods().AddTodaywork(usertodo, id)
                          : tomorrow
                              ? DatabaseMethods().AddTomorrowwork(usertodo, id)
                              : nextweek
                                  ? DatabaseMethods().AddNextweekwork(usertodo, id)
                                  : Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xff008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

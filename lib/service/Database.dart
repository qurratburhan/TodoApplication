import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future AddTodaywork(Map <String,dynamic> useTodadayMap,String id) async{
  return await FirebaseFirestore.instance
  .collection("Today")
  .doc(id)
  .set(useTodadayMap);
  }


  Future AddTomorrowwork(Map <String,dynamic> useTodadayMap,String id) async{
  return await FirebaseFirestore.instance
  .collection("Tomorrow")
  .doc(id)
  .set(useTodadayMap);
  }

  Future AddNextweekwork(Map <String,dynamic> useTodadayMap,String id) async{
  return await FirebaseFirestore.instance
  .collection("NextWeek")
  .doc(id)
  .set(useTodadayMap);
  }
  Future<Stream<QuerySnapshot>> getallthework(String day) async{

    return await FirebaseFirestore.instance.collection(day).snapshots();
  }


  // Update task details (generic update function)
  

  // Delete a task from a specific day
  Future<void> deleteTask(String id, String day) async {
    return await FirebaseFirestore.instance
        .collection(day)
        .doc(id)
        .delete();
  }

Future updateifTicked(String id, String day) async {
    return await FirebaseFirestore.instance
        .collection(day)
        .doc(id)
        .update({"Yes": true});
  }

  // Update Task
  Future updateTask(String id, String updatedWork, String day) async {
    return await FirebaseFirestore.instance
        .collection(day)
        .doc(id)
        .update({"Work": updatedWork});
  }
  // Read a specific task by its ID
  Future<DocumentSnapshot> getTaskById(String id, String day) async {
    return await FirebaseFirestore.instance
        .collection(day)
        .doc(id)
        .get();
  }

  // Delete all tasks for a specific day
  Future<void> deleteAllTasks(String day) async {
    var snapshots = await FirebaseFirestore.instance.collection(day).get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}

 

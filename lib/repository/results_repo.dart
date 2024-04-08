import 'package:assignment_3/database/database_service.dart';
import 'package:assignment_3/models/results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

class ResultRepo{
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Save results locally
  Future<void> saveResultsLocally(Results results) async {
    final Database db = await _databaseHelper.database;
    await db.insert('results', results.toJson());
  }

  // Fetch results locally
  Future<List<Results>> fetchResultsLocally() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> resultMaps = await db.query('results');
    return List.generate(resultMaps.length, (i) {
      return Results.fromJson(resultMaps[i]);
    });
  }

  // Save results on Firebase
  Future<void> saveResultsOnFirebase(Results results) async {
    await FirebaseFirestore.instance.collection('results').add(results.toJson());
  }

  // Fetch results from Firebase
  Future<List<Results>> fetchResultsFromFirebase() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('results').get();
    return snapshot.docs.map((doc) => Results.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  // Save results both locally and on Firebase
  Future<void> saveResults(Results results) async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet, save results locally
      await saveResultsLocally(results);
    } else {
      // If internet is available, save results on Firebase
      await saveResultsOnFirebase(results);
    }
  }

  // Fetch results both locally and from Firebase
  Future<List<Results>> fetchResults() async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet, fetch results locally
      return await fetchResultsLocally();
    } else {
      // If internet is available, fetch results from Firebase
      return await fetchResultsFromFirebase();
    }
  }
}
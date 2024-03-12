import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to quiz list
            },
            child: Text('View Quiz List'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to create quiz page
            },
            child: Text('Create Quiz'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to quiz results page
            },
            child: Text('View Quiz Results'),
          ),
        ],
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
      ),
      body: ListView.builder(
        itemCount: 5, // Example, replace with actual quiz count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Quiz ${index + 1}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to update quiz page
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Delete quiz logic
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuizResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Text('Table of Quiz Results'),
      ),
    );
  }
}

import 'package:assignment_3/models/results.dart';
import 'package:assignment_3/repository/results_repo.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final ResultRepo _resultRepo = ResultRepo(); // Instantiate ResultRepo
  List<Results> _results = []; // List to store fetched results

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  // Method to fetch results from repository
  void _fetchResults() async {
    List<Results> results = await _resultRepo.fetchResults();
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
      ),
      body: _results.isEmpty
          ? Center(
              child: Text('No results available'),
            )
          : _buildResultsWidget(), // Build the widget based on results
    );
  }



  // Method to build results widget
  // Widget _buildResultsWidget() {
  //   return ListView.builder(
  //     itemCount: _results.length,
  //     itemBuilder: (context, index) {
  //       Results result = _results[index];
  //       return Padding(
  //         padding: EdgeInsets.symmetric(vertical: 8.0),
  //         child: Card(
  //           elevation: 2,
  //           child: ListTile(
  //             title: Text('Result ID: ${result.id}'),
  //             subtitle: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Quiz ID: ${result.quiz_id}'),
  //                 Text('Score: ${result.score}'),
  //                 Text('Student: ${result.student_email}'),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
// }
// Method to build results widget
Widget _buildResultsWidget() {
  return ListView.builder(
    itemCount: _results.length,
    itemBuilder: (context, index) {
      Results result = _results[index];
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result.quiz_title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quiz ID: ${result.quiz_id}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Score: ${result.score}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Student: ${result.student_email}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
  }



// class ResultsPage extends StatefulWidget {
//   @override
//   _ResultsPageState createState() => _ResultsPageState();
// }

// class _ResultsPageState extends State<ResultsPage> {
//   final ResultRepo _resultRepo = ResultRepo(); // Instantiate ResultRepo
//   List<Results> _results = []; // List to store fetched results

//   @override
//   void initState() {
//     super.initState();
//     _fetchResults();
//   }

//   // Method to fetch results from repository
//   void _fetchResults() async {
//     List<Results> results = await _resultRepo.fetchResults();
//     setState(() {
//       _results = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Test Results'),
//       ),
//       body: _results.isEmpty
//           ? Center(
//               child: Text('No results available'),
//             )
//           : _buildResultsWidget(), // Build the widget based on results
//     );
//   }

//   // Method to build results widget
//   Widget _buildResultsWidget() {
//     // You can choose either CardView or TableView here
//     // return _buildCardView();
//     return _buildTableView();
//   }

//   // Method to build card view of results
//   Widget _buildCardView() {
//     return ListView.builder(
//       itemCount: _results.length,
//       itemBuilder: (context, index) {
//         Results result = _results[index];
//         return Card(
//           child: ListTile(
//             title: Text('Result ID: ${result.id}'),
//             subtitle: Text('Quiz ID: ${result.quiz_id}\nScore: ${result.score}'),
//             trailing: Text('Student: ${result.student_email}'),
//           ),
//         );
//       },
//     );
//   }

//   // Method to build table view of results
//   Widget _buildTableView() {
//     return DataTable(
//       columns: [
//         DataColumn(label: Text('Result ID')),
//         DataColumn(label: Text('Quiz ID')),
//         DataColumn(label: Text('Quiz Title')),
//         DataColumn(label: Text('Score')),
//         DataColumn(label: Text('Student')),
//       ],
//       rows: _results.map((result) {
//         return DataRow(
//           cells: [
//             DataCell(Text(result.id)),
//             DataCell(Text(result.quiz_id)),
//             DataCell(Text(result.quiz_title)),
//             DataCell(Text(result.score)),
//             DataCell(Text(result.student_email)),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksstudentmanagement/model/student.dart';
import 'package:marksstudentmanagement/view_model/student_view_model.dart';

class StudentView extends ConsumerStatefulWidget {
  const StudentView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentViewState();
}

class _StudentViewState extends ConsumerState<StudentView> {
  var gap = const SizedBox(
    height: 10,
  );
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController marksController = TextEditingController();
  // bool addingStudent = false; // Track the progress state
  String? selectedCourse;
  List<String> courses = [
    'wep-api',
    'flutter',
    'Design thinking',
    'Data Science'
  ];
  int? totalMarks;
  String status = 'None';

  String calculateResult(List<Student> students) {
    for (var student in students) {
      if (student.marks! < 40) {
        return 'Fail';
      }
    }
    return 'Pass';
  }

  String calculateDivision(List<Student> students) {
    double averageMarks =
        students.map((student) => student.marks).reduce((a, b) => a! + b!)! /
            students.length;

    if (averageMarks >= 60) {
      return '1st';
    } else if (averageMarks >= 50) {
      return '2nd';
    } else if (averageMarks >= 40) {
      return '3rd';
    } else {
      return 'Fail';
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(studentViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Marks'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: fnameController,
            decoration: const InputDecoration(labelText: "First Name"),
          ),
          gap,
          TextFormField(
            controller: lnameController,
            decoration: const InputDecoration(labelText: "Last Name"),
          ),
          gap,
          DropdownButtonFormField<String>(
            value: selectedCourse,
            onChanged: (newValue) {
              setState(() {
                selectedCourse = newValue!;
              });
            },
            items: courses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Course'),
          ),
          gap,
          TextFormField(
            controller: marksController,
            decoration: const InputDecoration(labelText: "Marks"),
          ),
          gap,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Student student = Student(
                  fname: fnameController.text.trim(),
                  lname: lnameController.text.trim(),
                  course: selectedCourse,
                  marks: int.parse(marksController.text.trim()),
                );

                ref.read(studentViewModelProvider.notifier).addStudent(student);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student Added Successfully'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ),
          if (data.students.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Marks')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: data.students.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(Text(student.fname!)),
                        DataCell(Text(student.marks.toString())),
                        DataCell(
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(studentViewModelProvider.notifier)
                                  .deleteStudent(student);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          gap,
          if (data.students.isNotEmpty)
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as desired
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Marks: ${data.students.map((student) => student.marks).reduce((a, b) => a! + b!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Result: ${calculateResult(data.students)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Division: ${calculateDivision(data.students)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            const Text('No Data')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:medisecure/services/tests_service.dart';
import 'package:medisecure/views/dashboard/side_menu/side_menu.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MediSecure"),
        ),
        drawer: SideMenu(),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Pacientes', '78'),
                      _buildStatCard('Citas', '12'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Pacientes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildAppointmentCard(
                          'John Smith',
                          '10:00 AM',
                          'General Checkup',
                        ),
                        _buildAppointmentCard(
                          'Emily Johnson',
                          '11:30 AM',
                          'Dental Cleaning',
                        ),
                        _buildAppointmentCard(
                          'Michael Williams',
                          '2:00 PM',
                          'Eye Examination',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

Widget _buildStatCard(String title, String value) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAppointmentCard(
    String patientName, String time, String description) {
  return Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(
        patientName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time: $time'),
          Text('Description: $description'),
        ],
      ),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Handle appointment tap
      },
    ),
  );
}

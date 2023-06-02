import 'package:flutter/material.dart';
import 'package:medisecure/services/auth_service.dart';
import 'package:medisecure/views/dashboard/dashboard.dart';
import 'package:medisecure/views/dashboard/tests/tests.dart';
import 'package:medisecure/views/login/login.dart';
import 'package:medisecure/views/user_page/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  SideMenu({super.key});
  final AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => FutureBuilder(
    future: getLocalData(),
    builder: (context, snapshot) {
      print(snapshot.data);
      return Material(
    color: Colors.blue.shade700,
    child: InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => UserPage()));
      },  
      child: Container(
        color: Colors.blue.shade700,
        padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/49454955?v=4"),
            ),
            SizedBox(height: 12),
            Text("Carlos Vasquez",
                style: TextStyle(fontSize: 28, color: Colors.white)),
            Text("cvasquez@medicorp.com",
                style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    ),
  );
    },
  );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_information),
              title: const Text("Tests"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Tests()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Workflow"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text("Updates"),
              onTap: () {},
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Plugins"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () async {
                Navigator.of(context).pop();

                
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLoggedIn", false);



                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      );

  // {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         DrawerHeader(
  //           child: Text(
  //             'MediSecure',
  //             style: TextStyle(color: Colors.white, fontSize: 25),
  //           ),
  //           decoration: BoxDecoration(
  //               color: Colors.green,
  //               image: DecorationImage(
  //                   fit: BoxFit.fill,
  //                   image: AssetImage('assets/images/font1.jpg'))),
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.input),
  //           title: Text('Welcome'),
  //           onTap: () => {},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.verified_user),
  //           title: Text('Profile'),
  //           onTap: () => {Navigator.of(context).pop()},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.settings),
  //           title: Text('Settings'),
  //           onTap: () => {Navigator.of(context).pop()},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.border_color),
  //           title: Text('Feedback'),
  //           onTap: () => {Navigator.of(context).pop()},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.exit_to_app),
  //           title: Text('Logout'),
  //           onTap: () async {
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             prefs.setBool("isLoggedIn", false);
  //             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => Login())));
  //             },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

Future getLocalData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return [prefs.getString('user'), prefs.getString("username")];
}
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:medisecure/services/auth_service.dart';
import 'package:medisecure/views/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthServices authService = AuthServices();

  // Auth User
  Future<String?> _authUser(LoginData data) async {

      var res = await authService.loginUser(data.name, data.password);

      SharedPreferences prefs = await SharedPreferences.getInstance(); 
      prefs.setBool("isLoggedIn", res);
      
      if (!res){
        return "Cannot login, check the email and password";
      } else {
        return null;
      }

    }

    Future<String?> _signupUser(SignupData data) async {
      String? message;
      var res = await authService.registerUser("cvasquez@medisecure.com", "Carlos Vasquez", "12345", "Pacient");
      if (res) {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
        return null;
      } else {
        return "Error. Cannot create user at this moment.";
      }
  }

  
  // Recover Password
  Future<String?> _recoverPassword(String name) async {
    String? user = null;

    return user;
  }

  @override
  Widget build(BuildContext context) {
    
    return FlutterLogin(
      title: "MediSecure",
      onLogin: _authUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _signupUser,
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => Dashboard())));
      },
    );
  }
}
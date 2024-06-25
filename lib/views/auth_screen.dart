import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../utils/app_theme.dart';
import '../models/auth_services.dart';
import 'home_page.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FlutterLogin(
            theme: LoginTheme(
              primaryColor: AppColors.primaryColor,
              accentColor: AppColors.primaryColor,
              titleStyle: const TextStyle(color: AppColors.lightGrey),
              textFieldStyle: const TextStyle(
                color: Colors.black,
              ),
              buttonTheme: const LoginButtonTheme(
                backgroundColor: AppColors.primaryColor,
              ),



            ),
            logo: const AssetImage('assets/images/logo.png'),


            onSignup: (data)=> AuthServices.signUp(data.name!, data.password!),
            onLogin: (data) => AuthServices.signIn(data.name, data.password),
            onRecoverPassword: (email) => AuthServices.recoverPassword(email),
            onSubmitAnimationCompleted: ()  {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (ctx) {
                    return const HomePage();
                  }));

            }),
      ),
    );
  }
}

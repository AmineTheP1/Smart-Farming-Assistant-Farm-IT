import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Uncommented for Firebase
import 'home.dart'; // Your HomePage
import 'sign_up_screen.dart'; // Import the new sign-up screen
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginScreen(),
));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(const Duration(seconds: 10), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      );
    },
  );
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String pass;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    // Using Firebase Auth to check current user
    var user = FirebaseAuth.instance.currentUser;
    // If 'user' is not null, they're logged in => push to Home screen
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // ------------------------------------------------
            // Top background image & "Login" text
            // ------------------------------------------------

            SizedBox(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.fill,
                    height: 400,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------
            // INPUT FORM FIELDS
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  // TextFields
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        // Email
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) => email = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email or Phone number",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        // Password
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: true,
                            onChanged: (value) => pass = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // LOGIN BUTTON
                  // ------------------------------------------------

                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF53BE53), // Green
                          Color(0xFF00EF00), // Dark green
                        ],
                      ),
                    ),
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // Firebase login logic
                            if (email.isNotEmpty && pass.isNotEmpty) {
                              await auth.signInWithEmailAndPassword(
                                email: email,
                                password: pass,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            } else {
                              throw Exception("Please enter email and password");
                            }
                          } catch (e) {
                            _showErrorDialog(context, e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // SIGN-UP BUTTON
                  // ------------------------------------------------

                  SizedBox(
                    width: 400,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to Sign Up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // Login With Google BUTTON
                  // ------------------------------------------------

                  SizedBox(
                    width: 400,
                    height: 45,
                    child: OutlinedButton(
                        onPressed: () async {
                          try {
                            final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                            if (googleUser == null) {
                              // The user canceled the sign-in
                              return;
                            }

                            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth.accessToken,
                              idToken: googleAuth.idToken,
                            );

                            // Sign in with credential
                            await FirebaseAuth.instance.signInWithCredential(credential);

                            // Navigate to home after successful login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage()),
                            );
                          } catch (e) {
                            _showErrorDialog(context, e.toString());
                          }
                        },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',  // <-- your local Google logo asset
                            height: 24.0,
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            "Login with Google",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ------------------------------------------------
                  // Universia Logo
                  // ------------------------------------------------

                  const Image(
                    image: AssetImage('assets/images/7.jpg'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

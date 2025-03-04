import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_management_app/widgets/custom_textfield.dart';
import 'package:hr_management_app/widgets/custom_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thành công!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Đã xảy ra lỗi";
      if (e.code == 'user-not-found') {
        errorMessage = "Tài khoản không tồn tại";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Mật khẩu không chính xác";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", height: 100),
                    SizedBox(height: 20),
                    Text("Hooman", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    CustomTextField(controller: _emailController, hintText: "Email", label: "Email", isPassword: false),
                    SizedBox(height: 10),
                    CustomTextField(controller: _passwordController, hintText: "Password", isPassword: true, label: '',),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : CustomButton(onPressed: _login, text: "Login"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

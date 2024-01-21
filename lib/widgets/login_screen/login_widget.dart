import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/theme/button_style.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to your account"),
      ),
      body: ListView(
        children: [
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _textStyle = const TextStyle(fontSize: 16, color: Colors.black,);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25,),
          _FormWidget(),
          const SizedBox(height: 25,),
          Text(
            "In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.",
            style: _textStyle,
          ),
          TextButton(
            onPressed: (){},
              child: Text("Register"),
            style: AppButtonStyle.linkButton
          ),
          const SizedBox(height: 25,),
          Text(
            "If you signed up but didn't get your verification email.",
            style: _textStyle,
          ),
          TextButton(
            onPressed: (){},
            child: Text("Verify email"),
            style: AppButtonStyle.linkButton
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({super.key});

  @override
  State<_FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(/*text: "admin"*/);
  final _passwordTextController = TextEditingController();
  String? errorText = null;

  void _auth(){
    final login = _loginTextController.text;
    final password = _passwordTextController.text;

    if(login == "admin") {
      errorText = null;
      //Navigator.of(context).pushNamed("/main_screen");
      Navigator.of(context).pushReplacementNamed("/main_screen");


    } else {
      errorText = "Incorrect username or password";
    }

    setState(() {});
  }

  void _resetPassword(){

  }

  @override
  Widget build(BuildContext context) {
    const _buttonAndBordColor = Color(0xFF01B4E4);
    final _textStyle = const TextStyle(fontSize: 16, color: Color(0xFF212529));
    const _textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _buttonAndBordColor)),
      isCollapsed: true,
    );

    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(errorText != null)...[
          Text(
            errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 20,),
        ],
        Text(
          "Username",
          style: _textStyle,
        ),
        const SizedBox(height: 5,),
        TextField(
          controller: _loginTextController,
          decoration: _textFieldDecorator,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20,),
        Text(
          "Password",
          style: _textStyle,
        ),
        const SizedBox(height: 5,),
        TextField(
          controller: _passwordTextController,
          decoration: _textFieldDecorator,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 25),
        Row(
          children: [
            ElevatedButton(
              style: AppButtonStyle.borderButton,
              onPressed: _auth,
              child: Text("Login"),
            ),
            SizedBox(width: 30),
            TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: _resetPassword,
              child: Text("Reset password"),
            )
          ],
        ),
      ],
    );
  }
}

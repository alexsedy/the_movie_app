import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/auth_screen/auth_model.dart';
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
        // titleTextStyle: TextStyle(
        //   color: Colors.white,
        //   fontSize: 24,
        // ),
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
          const _FormWidget(),
          const SizedBox(height: 25,),
          Text(
            "In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.",
            style: _textStyle,
          ),
          TextButton(
            onPressed: (){},
            style: AppButtonStyle.linkButton,
              child: const Text("Register")
          ),
          const SizedBox(height: 25,),
          Text(
            "If you signed up but didn't get your verification email.",
            style: _textStyle,
          ),
          TextButton(
            onPressed: (){},
            style: AppButtonStyle.linkButton,
            child: const Text("Verify email")
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);

    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF01B4E4))),
      isCollapsed: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text(
          "Username",
          style: TextStyle(fontSize: 16, color: Color(0xFF212529)),
        ),
        const SizedBox(height: 5,),
        TextField(
          controller: model?.usernameTextController,
          decoration: textFieldDecorator,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20,),
        const Text(
          "Password",
          style: TextStyle(fontSize: 16, color: Color(0xFF212529)),
        ),
        const SizedBox(height: 5,),
        TextField(
          controller: model?.passwordTextController,
          decoration: textFieldDecorator,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 30),
            TextButton(
              style: AppButtonStyle.linkButton,
              onPressed: (){},
              child: const Text("Reset password"),
            )
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AuthModel>(context);

    final loginAction = model?.canStartAuth == false
      ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: Colors.white),
      )
      : const Text("Login");

    return ElevatedButton(
      style: AppButtonStyle.borderButton,
      onPressed: model?.canStartAuth == true ? () => model?.auth(context) : null,
      child: loginAction,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage = NotifierProvider.watch<AuthModel>(context)?.errorMessage;

    if(errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 17,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/account_screen/account_model.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  @override
  void initState() {
    super.initState();
    NotifierProvider.read<AccountModel>(context)?.checkLoginStatus();
    NotifierProvider.read<AccountModel>(context)?.getAccountState();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _ColorPaletteWidget(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WelcomeTextWidget(),
                      _LoginButtonWidget(),
                    ],
                  ),
                )
              ],
            ),
            _AccountBodyWidget(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeTextWidget extends StatelessWidget {
  const _WelcomeTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AccountModel>(context);
    final accountSate = model?.accountSate;
    final username = accountSate?.username;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        username != null ? "Hello, $username" : "Hello, Guest",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LoginButtonWidget extends StatelessWidget {
  const _LoginButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AccountModel>(context);
    final isLoggedIn = model?.isLoggedIn;

    if(isLoggedIn == null) {
      return const SizedBox.shrink();
    }

    if(isLoggedIn) {
      return ElevatedButton(
        onPressed: () {
          model?.makeLogout();
          Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent.shade100),
        ),
        child: const Text("Logout"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth),
        child: const Text("Login"),
      );
    }
  }
}

class _ColorPaletteWidget extends StatelessWidget {
  const _ColorPaletteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.greenAccent,
    );
  }
}

class _AccountBodyWidget extends StatelessWidget {
  const _AccountBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



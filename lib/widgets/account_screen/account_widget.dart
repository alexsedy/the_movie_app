import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/account_screen/account_model.dart';


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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _ColorPaletteWidget(),
                    SizedBox(width: 10,),
                    _WelcomeTextWidget(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _LoginButtonWidget(),
                ),
              ],
            ),
            SizedBox(height: 70,),
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
    final isLoggedIn = model?.isLoggedIn;

    //временное решение чтобы получить accountSate
    if(isLoggedIn != null && isLoggedIn && accountSate == null) {
      model?.checkLoginStatus();
    }

    if (isLoggedIn != null && isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              username ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Guest",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
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
        onPressed: () => model?.makeLogout(context),
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent.shade100),
        ),
        child: const Text("Logout"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => model?.makeLogin(context),
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
    final model = NotifierProvider.watch<AccountModel>(context);
    final isLoggedIn = model?.isLoggedIn;
    
    if(isLoggedIn == null || isLoggedIn == false) {
      return const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80,),
            Text(
              "Lists not available. Please login.",
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.list, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "Lists",
                          style: TextStyle(
                            fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "Favorite",
                          style: TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bookmark, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "Watchlist",
                          style: TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "Rated",
                          style: TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



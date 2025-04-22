import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/account_screen/viewmodel/account_viewmodel.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AccountViewModel, bool>((value) => value.isLoggedIn);

    if(isLoggedIn) {
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
                    child: _LogoutButtonWidget(),
                  ),
                ],
              ),
              SizedBox(height: 70,),
              _AccountBodyWidget(),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const _ColorPaletteWidget(),
                      const SizedBox(width: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.hello,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              context.l10n.guest,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const _LoginButtonWidget(),
                ],
              ),
              const SizedBox(height: 70,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80,),
                    Text(
                      context.l10n.noLoginAccountMessage,
                      style: const TextStyle(
                          fontSize: 24
                      ),
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
}

class _LoginButtonWidget extends StatelessWidget {
  const _LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AccountViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child:  ElevatedButton(
        onPressed: () => model.makeLogin(context),
        child: Text(context.l10n.login),
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
    final username = context.select<AccountViewModel, String?>((m) => m.accountSate?.username);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.hello,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            username ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _LogoutButtonWidget extends StatelessWidget {
  const _LogoutButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<AccountViewModel>();
    final isLinked = context.select<AccountViewModel, bool>((m) => m.isLinked);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(context.l10n.confirmLeaveMessage),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          await model.makeLogout(context);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(context.l10n.yes),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          // onPressed: () => model?.makeLogout(context),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.redAccent.shade100),
          ),
          child: Text(context.l10n.logout),
        ),
        isLinked
            ? ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.redAccent.shade100),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Are you sure you want to unlink your account?"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          await model.unlinkAccount(context);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(context.l10n.yes),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text("Unlink account"),
        )
            : ElevatedButton(
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  title: Text("Link your account with My Movie"),
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Link your TMDB account to My Movie to get benefits:",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10,),
                        Text("• AI-powered playlist generation by genre."),
                        Text("• AI-powered playlist generation by description."),
                        Text("• Tracking movies and TV shows (including individual episodes)."),
                        Text("• Receive notifications about the release of new episodes."),
                        Text("• Receive notifications about movie release dates."),
                        Center(
                          child: Column(
                            children: [
                              SignInButton(Buttons.google, onPressed: () async {
                                showDialog (
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                await model.linkAccountWithGoogle(context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                // Navigator.pop(context);
                              }),
                              SignInButton(Buttons.apple, onPressed: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          child: Text("Link account"),
        ),
      ],
    );
  }
}

class _ColorPaletteWidget extends StatelessWidget {
  const _ColorPaletteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 40,
      backgroundColor: Colors.greenAccent,
    );
  }
}

class _AccountBodyWidget extends StatelessWidget {
  const _AccountBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AccountViewModel>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onUserLists(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.list, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.userLists,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onFavoriteList(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.favorite,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onWatchlistList(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bookmark, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.watchlist,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onRatedList(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.rated,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onRecommendationList(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.recommend, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.recommendation,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
        if(model.isLinked)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model.onAIFeatureScreen(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.try_sms_star_outlined, size: 40,),
                        const SizedBox(width: 15,),
                        Text(
                          context.l10n.aiRecommendation,
                          style: const TextStyle(
                              fontSize: 24
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
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
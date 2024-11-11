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
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AccountModel>(context);
    final isLoggedIn = model?.isLoggedIn;

    if(isLoggedIn != null && isLoggedIn) {
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
                      Padding(
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
                      ),
                    ],
                  ),
                  _LoginButtonWidget(),
                ],
              ),
              SizedBox(height: 70,),
              Center(
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
              ),
            ],
          ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child:  ElevatedButton(
        onPressed: () => model?.makeLogin(context),
        child: const Text("Login"),
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
  }
}

class _LogoutButtonWidget extends StatelessWidget {
  const _LogoutButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AccountModel>(context);
    final isLoggedIn = model?.isLoggedIn;

    if(isLoggedIn == null) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Do you really want to leave?"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
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
                      await model?.makeLogout(context);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
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
      child: const Text("Logout"),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model?.onUserLists(context),
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
            onTap: () => model?.onFavoriteList(context),
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
            onTap: () => model?.onWatchlistList(context),
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
            onTap: () => model?.onRatedList(context),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InkWell(
            onTap: () => model?.onRecommendationList(context),
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
                        Icon(Icons.recommend, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "Recommendation",
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
            onTap: () => model?.onAIFeatureScreen(context),
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
                        Icon(Icons.try_sms_star_outlined, size: 40,),
                        SizedBox(width: 15,),
                        Text(
                          "AI Recommendation",
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


// class AccountWidget extends StatefulWidget {
//   const AccountWidget({super.key});
//
//   @override
//   State<AccountWidget> createState() => _AccountWidgetState();
// }
//
// class _AccountWidgetState extends State<AccountWidget> {
//   @override
//   void initState() {
//     super.initState();
//     NotifierProvider.read<AccountModel>(context)?.checkLoginStatus();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     NotifierProvider.read<AccountModel>(context)?.checkLoginStatus();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     _ColorPaletteWidget(),
//                     SizedBox(width: 10,),
//                     _WelcomeTextWidget(),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: _LoginButtonWidget(),
//                 ),
//               ],
//             ),
//             SizedBox(height: 70,),
//             _AccountBodyWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _WelcomeTextWidget extends StatelessWidget {
//   const _WelcomeTextWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<AccountModel>(context);
//     final accountSate = model?.accountSate;
//     final username = accountSate?.username;
//     final isLoggedIn = model?.isLoggedIn;
//
//     if (isLoggedIn != null && isLoggedIn) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Hello,",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               username ?? "",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Hello,",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "Guest",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
//
// class _LoginButtonWidget extends StatelessWidget {
//   const _LoginButtonWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<AccountModel>(context);
//     final isLoggedIn = model?.isLoggedIn;
//
//     if(isLoggedIn == null) {
//       return const SizedBox.shrink();
//     }
//
//     if(isLoggedIn) {
//       return ElevatedButton(
//         onPressed: () => model?.makeLogout(context),
//         style: ButtonStyle(
//           backgroundColor: MaterialStatePropertyAll(Colors.redAccent.shade100),
//         ),
//         child: const Text("Logout"),
//       );
//     } else {
//       return ElevatedButton(
//         onPressed: () => model?.makeLogin(context),
//         child: const Text("Login"),
//       );
//     }
//   }
// }
//
// class _ColorPaletteWidget extends StatelessWidget {
//   const _ColorPaletteWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return const CircleAvatar(
//       radius: 50,
//       backgroundColor: Colors.greenAccent,
//     );
//   }
// }
//
// class _AccountBodyWidget extends StatelessWidget {
//   const _AccountBodyWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<AccountModel>(context);
//     final isLoggedIn = model?.isLoggedIn;
//
//     if(isLoggedIn == null || isLoggedIn == false) {
//       return const Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 80,),
//             Text(
//               "Lists not available. Please login.",
//               style: TextStyle(
//                 fontSize: 24
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: InkWell(
//             onTap: (){},
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               width: double.infinity,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.list, size: 40,),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Lists",
//                           style: TextStyle(
//                             fontSize: 24
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.arrow_forward_ios),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: InkWell(
//             onTap: (){},
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               width: double.infinity,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.favorite, size: 40,),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Favorite",
//                           style: TextStyle(
//                               fontSize: 24
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.arrow_forward_ios),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: InkWell(
//             onTap: (){},
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               width: double.infinity,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.bookmark, size: 40,),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Watchlist",
//                           style: TextStyle(
//                               fontSize: 24
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.arrow_forward_ios),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: InkWell(
//             onTap: (){},
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               width: double.infinity,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.star, size: 40,),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Rated",
//                           style: TextStyle(
//                               fontSize: 24
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.arrow_forward_ios),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
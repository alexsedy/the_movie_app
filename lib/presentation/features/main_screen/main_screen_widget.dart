import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/di/dependencies.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/account_screen/account_view.dart';
import 'package:the_movie_app/presentation/features/account_screen/viewmodel/account_viewmodel.dart';
import 'package:the_movie_app/presentation/features/home_screen/home_view.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_viewmodel.dart';
import 'package:the_movie_app/presentation/features/main_screen/filter_widget.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_list_screen/movie_list_view.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_list_screen/viewmodel/movie_list_viewmodel.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_list_screen/tv_show_list_view.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_list_screen/viewmodel/tv_show_list_viewmodel.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  void onSelectTab(int index) {
    if (_selectedTab == index) {
      if(index == 1) {
        // movieViewModel.scrollToTop();
      } else if (index == 2) {
        // tvShowViewModel.scrollToTop();
      }
      return;
    }
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // movieListModel.loadContent();
    // tvShowListModel.loadContent();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final routeArguments = ModalRoute.of(context)?.settings.arguments;
    if(routeArguments != null) {
      _selectedTab = routeArguments as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieViewModel = getIt<MovieListViewModel>();
    final tvShowViewModel = getIt<TvShowListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("The Movie"),
        actions: [
          if(_selectedTab == 1)
            FilterMoviesButtonWidget(model: movieViewModel,),
          if(_selectedTab == 2)
            FilterMoviesButtonWidget(model: tvShowViewModel,),
          if (_selectedTab == 1 || _selectedTab == 2) IconButton(
            onPressed: () {
              final index = _selectedTab == 1 ? 0 : 1;
              getIt<HomeViewModel>().onHomeSearchScreen(context: context, index: index);
            },
            splashRadius: 15,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          ChangeNotifierProvider.value(
            value: getIt<HomeViewModel>(),
            child: const HomeView(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<MovieListViewModel>(),
            child: const MovieListView(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<TvShowListViewModel>(),
            child: const TvShowListView(),
          ),
          ChangeNotifierProvider.value(
            value: getIt<AccountViewModel>(),
            child: const AccountView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTab,
        onTap: onSelectTab,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.home
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_movies),
            label: context.l10n.movies
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.tv),
            label: context.l10n.tvShows
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: context.l10n.profile
          ),
        ],
      ),
    );
  }
}
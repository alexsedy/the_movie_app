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
import 'package:the_movie_app/presentation/widgets/widget_elements/error_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  late MovieListViewModel movieListModel;
  late TvShowListViewModel tvShowListModel;

  MovieListViewModel get movieViewModel => movieListModel;
  TvShowListViewModel get tvShowViewModel => tvShowListModel;

  void onSelectTab(int index) {
    if (_selectedTab == index) {
      if(index == 1) {
        movieViewModel.scrollToTop();
      } else if (index == 2) {
        tvShowViewModel.scrollToTop();
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
    movieListModel = getIt<MovieListViewModel>();
    tvShowListModel = getIt<TvShowListViewModel>();
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
    // final movieViewModel = getIt<MovieListViewModel>();
    // final tvShowViewModel = getIt<TvShowListViewModel>();

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.doYouReallyWantOut),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.l10n.yes),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "The Movie",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
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
            ChangeNotifierProvider.value(
              value: movieViewModel,
              child: const MovieListView(),
            ),
            ChangeNotifierProvider.value(
              value: tvShowViewModel,
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
      ),
    );
  }
}
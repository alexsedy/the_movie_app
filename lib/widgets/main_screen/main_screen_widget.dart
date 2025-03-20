import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/account_screen/account_model.dart';
import 'package:the_movie_app/widgets/account_screen/account_widget.dart';
import 'package:the_movie_app/widgets/home_screen/home_model.dart';
import 'package:the_movie_app/widgets/home_screen/home_widget.dart';
import 'package:the_movie_app/widgets/main_screen/filter_widget.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_list_screen/tv_show_list_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_list_screen/tv_show_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  final movieListModel = MovieListModel();
  final tvShowListModel = TvShowListModel();
  final homeModel = HomeModel();
  final accountModel = AccountModel();
  int _selectedTab = 0;
  bool isSearchOpen = false;

  void onSelectTab(int index) {
    if (_selectedTab == index) {
      if(index == 1) {
        movieListModel.scrollToTop();
      } else if (index == 2) {
        tvShowListModel.scrollToTop();
      }
      return;
    }
    setState(() {
      _selectedTab = index;
    });

    if(isSearchOpen) {
      isSearchOpen = !isSearchOpen;
    }
  }

  @override
  void initState() {
    super.initState();
    accountModel.checkLoginStatus();
    accountModel.checkLinkingStatus();
    movieListModel.loadContent();
    tvShowListModel.loadContent();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final routeArguments = ModalRoute.of(context)?.settings.arguments;
    if(routeArguments != null) {
      _selectedTab = routeArguments as int;
    }
    accountModel.checkLoginStatus();

    // final appModel = Provider.watch<MyAppModel>(context);
    // if(_locale != appModel?.locale) {
    //   appModel?.initLocaleForAPI();
    //   movieListModel.resetList();
    //   tvShowListModel.resetList();
    //   movieListModel.loadContent();
    //   tvShowListModel.loadContent();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isSearchOpen ? const SearchFieldWidget() : const Text("The Movie"),
        ),
        actions: [
          if(_selectedTab == 1)
            FilterMoviesButtonWidget(model: movieListModel,),
          if(_selectedTab == 2)
            FilterMoviesButtonWidget(model: tvShowListModel,),
          if (_selectedTab == 1 || _selectedTab == 2) IconButton(
            onPressed: () {
              setState(() {
                isSearchOpen = !isSearchOpen;
                movieListModel.clearFilterValue();
              });
            },
            splashRadius: 15,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isSearchOpen
                  ? const Icon(Icons.close)
                  : const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          NotifierProvider(
            create: () => homeModel,
            isManagingModel: false,
            child: const HomeWidget(),
          ),
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieListWidget(),
          ),
          NotifierProvider(
            create: () => tvShowListModel,
            isManagingModel: false,
              child: const TvShowListWidget(),
          ),
          NotifierProvider(
              create: () => accountModel,
              isManagingModel: false,
              child: const AccountWidget(),
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

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeModel = context.findAncestorStateOfType<_MainScreenWidgetState>()?.homeModel;
    final selectedTab = context.findAncestorStateOfType<_MainScreenWidgetState>()?._selectedTab;

    if(homeModel == null || selectedTab == null) {
      return SizedBox.shrink();
    }
    final searchController = homeModel.searchController;

    return TextField(
      onChanged: (value) {
        if(value.isNotEmpty) {
          if (selectedTab == 1) {
            homeModel.onHomeSearchScreen(context: context);
          } else {
            homeModel.onHomeSearchScreen(context: context, index: 1);
          }
        }
      },
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: context.l10n.search,
        hintStyle: const TextStyle(
          // color: Colors.white,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(
        // color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}
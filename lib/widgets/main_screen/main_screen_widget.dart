import 'package:flutter/material.dart';
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
    movieListModel.loadContent();
    tvShowListModel.loadContent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArguments = ModalRoute.of(context)?.settings.arguments;
    if(routeArguments != null) {
      _selectedTab = routeArguments as int;
    }
    // movieListModel.setupLocale(context);
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies),
            label: "Movie"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: "TV Shows"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
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
            homeModel.onHomeSearchScreen(context);
          } else {
            homeModel.onHomeSearchScreen(context);
          }
        }
      },
      controller: searchController,
      autofocus: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(
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
import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/auth_api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/account_screen/account_model.dart';
import 'package:the_movie_app/widgets/account_screen/account_widget.dart';
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

    //todo подумать над другим способом реализации закрытии поиска (лучший варинат переключать фокус поиска)
    if(isSearchOpen) {
      isSearchOpen = !isSearchOpen;
      movieListModel.closeSearch();
      tvShowListModel.closeSearch();
    }
  }

  @override
  void initState() {
    super.initState();
    movieListModel.firstLoadMovies();
    tvShowListModel.firstLoadTvShows();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // movieListModel.setupLocale(context);
    // movieListModel.loadMovies();
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
          if(_selectedTab == 1) const FilterMoviesButtonWidget(),
          IconButton(
            onPressed: () {
              setState(() {
                isSearchOpen = !isSearchOpen;
                SearchFieldWidget.searchController.text = "";
              });
              if(!isSearchOpen) {
                if(_selectedTab == 1) {
                  movieListModel.closeSearch();
                }
                if (_selectedTab == 2) {
                  tvShowListModel.closeSearch();
                }
              }
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
          Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.exit_to_app),
            )
          ),
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieListWidget()),
          NotifierProvider(
            create: () => tvShowListModel,
            isManagingModel: false,
              child: const TvShowListWidget()),
          NotifierProvider(
              create: () => accountModel,
              isManagingModel: false,
              child: const AccountWidget()),
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
  static final searchController = TextEditingController();
  const SearchFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieListModel = context.findAncestorStateOfType<_MainScreenWidgetState>()?.movieListModel;
    final tvShowListModel = context.findAncestorStateOfType<_MainScreenWidgetState>()?.tvShowListModel;
    final selectedTab = context.findAncestorStateOfType<_MainScreenWidgetState>()?._selectedTab;

    return TextField(
      onChanged: (text) {
        if(selectedTab == 1 && movieListModel != null) {
          movieListModel.searchMovies(text);
        }
        if (selectedTab == 2 && tvShowListModel != null) {
          tvShowListModel.searchTvShows(text);
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
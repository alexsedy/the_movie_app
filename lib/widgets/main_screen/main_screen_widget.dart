import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/provider/provider.dart';
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
          if(_selectedTab == 1) FilterMoviesButtonWidget(),
          IconButton(
            onPressed: () {
              setState(() {
                isSearchOpen = !isSearchOpen;
                SearchFieldWidget.searchController.text = "";
              });
              if(!isSearchOpen) {
                if(_selectedTab == 1) {
                  movieListModel.resetList();
                  movieListModel.loadMovies();
                  movieListModel.scrollToTop();
                }
                if (_selectedTab == 2) {
                  tvShowListModel.resetList();
                  tvShowListModel.loadTvShows();
                  tvShowListModel.scrollToTop();
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
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,  //todo реализовать кнопку вверх
      // floatingActionButton: Container(
      //   decoration: BoxDecoration(color: AppColors.mainBlue, borderRadius: BorderRadius.circular(30.0)),
      //   child: IconButton(
      //     color: Colors.white,
      //     splashRadius: 30,
      //     onPressed: () {  },
      //     icon: Icon(Icons.arrow_upward),),
      // ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Center(
            child: IconButton(
              onPressed: () => SessionDataProvider().setSessionId(null),
              icon: const Icon(Icons.exit_to_app),
            )
          ),
          NotifierProvider(
              create: () => movieListModel,
              isManagingModel: false,
            // model: movieListModel,
            child: const MovieListWidget()),
          NotifierProvider(
              create: () => tvShowListModel,
              isManagingModel: false,
              // model: tvShowListModel,
              child: const TvShowListWidget()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
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
        ],
        onTap: onSelectTab,
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


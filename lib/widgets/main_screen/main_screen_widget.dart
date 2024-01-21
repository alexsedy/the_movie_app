import 'package:flutter/material.dart';
import '../movie_list_screen/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  bool isSearchOpen = false;

  //todo реализация при которой виджеты сбрасываются [1]
  // static final List<Widget> _widgetOptions = <Widget>[
  //   Text("Home"),
  //   MovieListWidget(),
  //   Text("TV Shows"),
  // ];

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isSearchOpen ? SearchFieldWidget() : const Text("The Movie"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchOpen = !isSearchOpen;
                SearchFieldWidget.searchController.text = "";
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
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,  //todo реализовать кнопку вверх
      // floatingActionButton: Container(
      //   decoration: BoxDecoration(color: AppColors.mainBlue, borderRadius: BorderRadius.circular(30.0)),
      //   child: IconButton(
      //     color: Colors.white,
      //     splashRadius: 30,
      //     onPressed: () {  },
      //     icon: Icon(Icons.arrow_upward),),
      // ),
              //todo реализация при которой виджеты сбрасываются [2]
      // body: Center(
      //   child: _widgetOptions[_selectedTab],
      // ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Center(child: Text("Home")),
          MovieListWidget(),
          Center(child: Text("TV Shows")),
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
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}


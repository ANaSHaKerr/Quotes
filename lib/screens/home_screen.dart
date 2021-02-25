import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './favorites_quotes_screen.dart';
import './quote_day_screen.dart';
import 'QuoteList.dart';
import 'authors_screen.dart';

class HomeScreen extends StatefulWidget {
  static const roueName = '/HomeScreen';
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': QuoteDayScreen(),
        'title': 'Quote of the Day',
      },
      {
        'page': QuoteList(),
        'title': 'All Quotes',
      },
      {
        'page': FavoritesQuotesScreen(),
        'title': 'Your Favorite Quotes',
      },
      {'page': AuthorsScreen(), "title": 'Search Author'},
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(_pages[_selectedPageIndex]['title'],style: GoogleFonts.aclonica(),),
        centerTitle: true,
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.today),
            title: Text('Quote of the Day'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.format_quote),
            title: Text('All Quotes'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.search),
            title: Text('Search by Author'),
          ),
        ],
      ),
    );
  }
}

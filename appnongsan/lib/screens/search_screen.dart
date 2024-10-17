import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _searchHistory = [];
  List<String> _filteredHistory = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(_filterHistory);
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
      _filteredHistory = List.from(_searchHistory);
    });
  }

  void _filterHistory() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHistory = _searchHistory
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      _searchHistory.clear();
      _filteredHistory.clear();
    });
  }

  void _performSearch() {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      _saveSearchHistory(query);
      Navigator.pop(context, query);
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    if (!_searchHistory.contains(query)) {
      _searchHistory.add(query);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('searchHistory', _searchHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterHistory(); // Cập nhật danh sách khi xóa
                          },
                        ),
                      ),
                      onSubmitted: (value) => _performSearch(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tìm kiếm gần đây',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _clearSearchHistory,
                    child: Text(
                      'Xóa',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredHistory[index]),
                      onTap: () {
                        _searchController.text = _filteredHistory[index];
                        _performSearch();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
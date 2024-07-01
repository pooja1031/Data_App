import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoadingTab1 = false;
  bool _isLoadingTab2 = false;

  List<Map<String, dynamic>> _tab1Data = []; 
  List<String> _tab2Data = [
    'USA',
    'Canada',
    'UK',
    'Australia',
    'Germany',
    'India',
    'Japan',
    'China',
    'Brazil',
    'South Africa',
    'Mexico',
    'Argentina',
    'France',
    'Italy',
    'Spain',
  ]; 

  ScrollController _tab1ScrollController = ScrollController();
  ScrollController _tab2ScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadTabData(0); 
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      _loadTabData(1);
    }
  }

  void _loadTabData(int tabIndex) {
    setState(() {
      if (tabIndex == 0) {
        _isLoadingTab1 = true;
       
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isLoadingTab1 = false;
           
            List<Map<String, dynamic>> newData = List.generate(
              20,
              (index) => {'name': 'Person ${_tab1Data.length + index}', 'age': 20 + _tab1Data.length + index},
            );
            _tab1Data.addAll(newData);
          });
        });
      } else if (tabIndex == 1) {
        _isLoadingTab2 = true;
        
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isLoadingTab2 = false;
          });
        });
      }
    });
  }

  Widget _buildTab1() {
    _tab1ScrollController.addListener(() {
      if (_tab1ScrollController.position.pixels ==
          _tab1ScrollController.position.maxScrollExtent) {
        _loadTabData(0); 
      }
    });

    return Stack(
      children: [
        ListView.builder(
          controller: _tab1ScrollController,
          itemCount: _tab1Data.length + (_isLoadingTab1 ? 1 : 0), 
          itemBuilder: (context, index) {
            if (index == _tab1Data.length) {
              if (_isLoadingTab1) {
                return _buildLoadingIndicator();
              } else {
                return SizedBox.shrink();
              }
            }
            return ListTile(
              title: Text(_tab1Data[index]['name']),
              subtitle: Text('Age: ${_tab1Data[index]['age']}'),
            );
          },
        ),
        if (_isLoadingTab1) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildTab2() {
    return Stack(
      children: [
        ListView.builder(
          controller: _tab2ScrollController,
          itemCount: _tab2Data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_tab2Data[index]),
            );
          },
        ),
        if (_isLoadingTab2) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tabbed List ')),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'select  options',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Names'),
              Tab(text: 'Countries'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTab1(),
                _buildTab2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tab1ScrollController.dispose();
    _tab2ScrollController.dispose();
    super.dispose();
  }
}

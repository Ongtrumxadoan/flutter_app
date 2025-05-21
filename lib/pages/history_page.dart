import 'package:flutter/material.dart';
import '../services/ahp_service.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AHPService _ahpService = AHPService();
  List<String> _matrixIds = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    try {
      var matrixIds = await _ahpService.getMatrixHistory();
      setState(() {
        _matrixIds = matrixIds;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matrix History')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            _matrixIds.isEmpty
                ? Center(child: Text('No history available'))
                : ListView.builder(
                  itemCount: _matrixIds.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_matrixIds[index]),
                      onTap: () {
                        // Có thể thêm logic để xem chi tiết ma trận
                      },
                    );
                  },
                ),
      ),
    );
  }
}

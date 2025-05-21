import 'package:flutter/material.dart';
import '../services/ahp_service.dart';
import 'result_page.dart';
import 'history_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final AHPService _ahpService = AHPService();
  final List<List<TextEditingController>> _controllers = List.generate(
    3,
    (i) => List.generate(7, (j) => TextEditingController()),
  );
  final List<double> weights = [
    0.3622,
    0.2569,
    0.1458,
    0.1006,
    0.063,
    0.0431,
    0.0283,
  ];
  final List<String> criteria = [
    'Pin',
    'Hiệu Suất',
    'Camera',
    'Màn Hình',
    'Trọng Lượng',
    'Kết Nối',
    'Bộ Nhớ',
  ];

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(
      'token',
    ); // Hoặc clear toàn bộ nếu cần: await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Xóa toàn bộ stack
    );
  }

  void _submitData() async {
    List<List<double>> options = [];
    for (var row in _controllers) {
      List<double> rowData = [];
      for (var controller in row) {
        rowData.add(double.tryParse(controller.text) ?? 0.0);
      }
      options.add(rowData);
    }

    try {
      var result = await _ahpService.computeAHP(options, weights);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultPage(
                result: result,
                criteria: criteria,
                weights: weights,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Enter Options Data', style: TextStyle(fontSize: 20)),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Option'))),
                      ...criteria
                          .map((c) => TableCell(child: Center(child: Text(c))))
                          .toList(),
                    ],
                  ),
                  ...List.generate(3, (i) {
                    return TableRow(
                      children: [
                        TableCell(child: Center(child: Text('PA${i + 1}'))),
                        ...List.generate(criteria.length, (j) {
                          return TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextField(
                                controller: _controllers[i][j],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Weights'))),
                      ...weights
                          .map(
                            (w) => TableCell(
                              child: Center(child: Text(w.toString())),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

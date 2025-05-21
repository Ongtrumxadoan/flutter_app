import 'package:flutter/material.dart';
import '../services/export_service.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> result;
  final List<String> criteria;
  final List<double> weights;
  final ExportService _exportService = ExportService();

  ResultPage({
    required this.result,
    required this.criteria,
    required this.weights,
  });

  @override
  Widget build(BuildContext context) {
    List<double> scores = List<double>.from(result['scores']);
    int bestOption = result['best_option'];
    Map<String, dynamic> pairwiseMatrices = result['pairwise_matrices'];
    Map<String, dynamic> eigenVectors = result['eigen_vectors'];
    List<double> lambdaMaxList = List<double>.from(result['lambda_max_list']);
    List<double> CIList = List<double>.from(result['CI_list']);
    List<double> CRList = List<double>.from(result['CR_list']);

    bool allCRValid = CRList.every((cr) => cr < 0.1);

    return Scaffold(
      appBar: AppBar(
        title: Text('AHP Results'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              try {
                await _exportService.exportPDF();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('PDF Exported')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: () async {
              try {
                await _exportService.exportExcel();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Excel Exported')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pairwise Comparison Matrices',
              style: TextStyle(fontSize: 18),
            ),
            ...pairwiseMatrices.keys.map((crit) {
              int index = criteria.indexOf(crit);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Criteria: $crit', style: TextStyle(fontSize: 16)),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Text(crit))),
                          TableCell(child: Center(child: Text('PA1'))),
                          TableCell(child: Center(child: Text('PA2'))),
                          TableCell(child: Center(child: Text('PA3'))),
                          TableCell(child: Center(child: Text('Weight'))),
                        ],
                      ),
                      ...List.generate(3, (i) {
                        return TableRow(
                          children: [
                            TableCell(child: Center(child: Text('PA${i + 1}'))),
                            ...List.generate(3, (j) {
                              return TableCell(
                                child: Center(
                                  child: Text(
                                    pairwiseMatrices[crit][i][j]
                                        .toStringAsFixed(3),
                                  ),
                                ),
                              );
                            }),
                            TableCell(
                              child: Center(
                                child: Text(
                                  eigenVectors[crit][i].toStringAsFixed(3),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  Text('λ max: ${lambdaMaxList[index].toStringAsFixed(3)}'),
                  Text('CI: ${CIList[index].toStringAsFixed(3)}'),
                  Text(
                    'CR: ${CRList[index].toStringAsFixed(3)} ${CRList[index] < 0.1 ? "✅ (Valid)" : "❌ (Invalid)"}',
                  ),
                  Divider(),
                ],
              );
            }).toList(),
            if (allCRValid) ...[
              Text('Scores', style: TextStyle(fontSize: 18)),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Option'))),
                      TableCell(child: Center(child: Text('Score'))),
                    ],
                  ),
                  ...List.generate(scores.length, (i) {
                    return TableRow(
                      children: [
                        TableCell(child: Center(child: Text('PA${i + 1}'))),
                        TableCell(
                          child: Center(
                            child: Text(scores[i].toStringAsFixed(4)),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Best Option: PA$bestOption',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ] else ...[
              Text(
                '⚠️ Kết quả không được hiển thị vì một hoặc nhiều giá trị CR không hợp lệ (CR ≥ 0,1). Vui lòng điều chỉnh dữ liệu đầu vào.',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

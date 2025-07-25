import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/firebase.dart';
import '../../services/firebase/users/user_firebase.dart';
import '../../utils/user_auth_checker.dart';

class ListProductionsScreen extends StatefulWidget {
  const ListProductionsScreen({super.key});

  @override
  State<ListProductionsScreen> createState() => _ListProductionsScreenState();
}

class _ListProductionsScreenState extends State<ListProductionsScreen> {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  bool _isLoading = true;
  String _htmlContent = '';
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () => _loadProductions(),
    );
  }

  Future<void> _loadProductions() async {
    final UsersFirebaseService usersService = UsersFirebaseService();
    final user = await usersService.getUser();
    final uid = user?.uid;

    if (uid == null) return;

    final productions = await _firebaseService.getWhere('productions', 'usuario_id', uid);

    List<String> rows = productions.map((prod) {
      final produto = prod['produto'] ?? '';
      final quantidade = prod['quantidade'] ?? 0;
      final unidade = prod['unidade'] ?? '';
      final status = prod['status'] ?? '';
      final data = prod['data_estimada'] ?? '-';

      return "['$produto', '$quantidade $unidade', '$status', '$data']";
    }).toList();

    _htmlContent = _buildHtmlTable(rows.join(',\n'));

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_htmlContent);

    setState(() {
      _isLoading = false;
    });
  }

  String _buildHtmlTable(String rows) {
    return '''
    <html>
      <head>
        <style>
         html, body {
          margin: 0;
          padding: 0;
          color: white;
          height: 100%;
          background: linear-gradient(to bottom, #2A2A28, #4E5D4D);
        }

        #scroll_wrapper {
          overflow: scroll;
          height: 100vh;
          width: 100vw;
        }

        #scroll_wrapper::-webkit-scrollbar {
          width: 8px;
          height: 8px;
        }

        #scroll_wrapper::-webkit-scrollbar-thumb {
          background: #888;
          background-color: transparent;
          border-radius: 4px;
        }

        #scroll_wrapper::-webkit-scrollbar-track {
          background: transparent;
        }

        #table_container {
          width: max-content;
          margin: 0 auto;
          background-color: transparent;
        }

        .google-visualization-table-table {
          background-color: transparent !important;
          color: white;
          font-size: 22px;
          border-collapse: separate !important;
          border-spacing: 0;
          overflow: hidden;
        }

        .google-visualization-table-th {
          background-color: #2A2A28;
          color: #A5D6A7 !important;
          border: 1px solid #5b5b5b !important;
          padding: 18px 22px;
          text-align: center;
          font-size: 18px;
        }

        td {
          border: 1px solid #555555 !important;
          padding: 18px 22px;
          text-align: center;
          max-width: 180px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          font-size: 17px;
          background-color: transparent;
        }

        .google-visualization-table-tr-even {
          background-color: transparent !important;
        }

        .google-visualization-table-tr-odd {
          background-color: rgba(76, 175, 80, 0.12) !important;
        }
        </style>

        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
          google.charts.load('current', {'packages':['table']});
          google.charts.setOnLoadCallback(drawTable);

          function drawTable() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Produto');
            data.addColumn('string', 'Quantidade');
            data.addColumn('string', 'Status');
            data.addColumn('string', 'Data Estimada');

            data.addRows([
              $rows
            ]);

            var table = new google.visualization.Table(document.getElementById('table_container'));
            table.draw(data, {
              showRowNumber: false,
              allowHtml: true,
              cssClassNames: {
                headerRow: 'google-visualization-table-th',
                oddTableRow: 'google-visualization-table-tr-odd',
              }
            });
          }
        </script>
      </head>
      <body>
        <div id="scroll_wrapper">
          <div id="table_container"></div>
        </div>
      </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lista de Produções',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          ),
        ],
      ),
    );
  }
}

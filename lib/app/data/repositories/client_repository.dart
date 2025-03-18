import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//Feito porque tinha um certificado bloqueado o acesso a API
class MyHttpClient extends http.BaseClient {
  final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }
}

//Tokens de autorização e pesquisa da API
Future<String?> buscarClientePorId(String idCliente) async {
  final String host = 'https://ixc.nettri.com.br/webservice/v1/cliente';
  final String token = '30:2ff1da4a9b80b0fee85e3fb6b13bb5eaced17fed6a27cb848a22727d86af1dce';

  String basicAuth = 'Basic ${base64Encode(utf8.encode(token))}';

//Parametros dos filtros utilizados para achar o cliente corretamente
  final Map<String, dynamic> body = {
    'qtype': 'cliente.id',
    'query': idCliente,
    'oper': '=',
    'page': '1',
    'rp': '1',
    'sortname': 'cliente.id',
    'sortorder': 'desc',
  };
//Manda a requisação para a API
  try {
    final response = await http.post(
      Uri.parse(host),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
        'ixcsoft': 'listar',
      },
      body: jsonEncode(body),
    );

//Recebibendo da resposta da API
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['registros'] != null && jsonData['registros'].isNotEmpty) {
        return jsonData['registros'][0]['razao']; // Pegando o nome do cliente

      }
    } else {
      print('Erro ao buscar cliente: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }

  return null;
}

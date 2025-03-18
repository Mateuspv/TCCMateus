import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/ordens_de_servicos.dart';

//Usado porque a requisição estava sendo bloqueada por um certificado
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
Future<List<OrdemDeServico>> listarChamados() async {
  final String host = 'https://ixc.nettri.com.br/webservice/v1/su_oss_chamado';
  final String token = '30:2ff1da4a9b80b0fee85e3fb6b13bb5eaced17fed6a27cb848a22727d86af1dce';

  String basicAuth = 'Basic ${base64Encode(utf8.encode(token))}';

  //Parametros para utilizar filtros, caso necessario usar filtros,
  //alterar na response para post, e adicionar o body
  /*final Map<String, dynamic> body = {
    'qtype': 'su_oss_chamado.id',
    'query': '0',
    'oper': '>',
    'page': '1',
    'rp': '20',
    'sortname': 'su_oss_chamado.id',
    'sortorder': 'desc',
  };*/

  //Manda a requisação para a API
  try {
    final client = MyHttpClient();

    final response = await client.get(
      Uri.parse(host),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth, // Autenticação Basic
        'ixcsoft': 'listar', // Cabeçalho extra
      },
    );
//Recebibendo da resposta da API
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['registros'] != null) {
        List<dynamic> registros = jsonData['registros'];

        List<OrdemDeServico> ordens = registros.map((map) {
          return OrdemDeServico.fromMap(map);
        }).toList();

        //usado para pegar o nome na outra API com o codigo
        //Feito isso para que tudo seja encadeado ao usar 1 só função
        List<Future<OrdemDeServico>> futures =
        ordens.map((ordem) => ordem.fetchClientName()).toList();

        return await Future.wait(futures);
      }
    } else {
      print('Erro ao buscar dados: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
  return [];
}

void main() {
  listarChamados();
}

import '../repositories/client_repository.dart';

class OrdemDeServico {
  final int id;
  final int filial;
  final String clientId;
  final String? clientName;
  final String technician;
  final String date;
  final String message;
  final String location;
  final String dateReschedule;

  OrdemDeServico({
    required this.id,
    required this.filial,
    required this.clientId,
    this.clientName,
    required this.technician,
    required this.date,
    required this.message,
    required this.location,
    required this.dateReschedule,
  });

  //Mapa feito para converter os dados vindo da API,
  // ClientName inicado como null pois so vai receber valor após
  // o primeiro consumo da APi
  factory OrdemDeServico.fromMap(Map<String, dynamic> map) {
    return OrdemDeServico(
      id: int.tryParse(map['id'].toString()) ?? 0,
      filial: int.tryParse(map['id_filial'].toString()) ?? 0,
      clientId: map['id_cliente'].toString(),
      clientName: null,
      technician: map['id_tecnico'].toString(),
      date: map['data_agenda'] ?? "",
      message: map['mensagem'] ?? "",
      location: map['endereco'] ?? "",
      dateReschedule: map['data_reagendar'] ?? "",
    );
  }

  //Adicionado o nome do cliente apos já ter o codigo do cliente
  Future<OrdemDeServico> fetchClientName() async {
    String? name = await buscarClientePorId(clientId);
    return OrdemDeServico(
      id: id,
      filial: filial,
      clientId: clientId,
      clientName: name ?? 'Desconhecido',
      technician: technician,
      date: date,
      message: message,
      location: location,
      dateReschedule: dateReschedule,
    );
  }

  //Faz a transformação das listas vindo da API para uma lista de OrdemDeServico
  static List<OrdemDeServico> fromJsonList(Map<String, dynamic> json) {
    if (json['registros'] == null) return [];
    return List<OrdemDeServico>.from(
      (json['registros'] as List).map((item) => OrdemDeServico.fromMap(item)),
    );
  }
}

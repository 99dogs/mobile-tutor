import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tutor/shared/auth/auth_controller.dart';
import 'package:tutor/shared/models/avaliacao_model.dart';
import 'package:tutor/shared/models/response_data_model.dart';
import 'package:tutor/shared/models/usuario_logado_model.dart';

class AvaliacaoRepository {
  final _endpointApi = dotenv.get('ENDPOINT_API', fallback: '');
  final _authController = AuthController();
  var _client = http.Client();
  String _token = "";

  Future<Map<String, String>> headers() async {
    var headers = Map<String, String>();
    UsuarioLogadoModel usuario = await _authController.obterSessao();

    if (usuario.token != null && usuario.token!.isNotEmpty) {
      _token = usuario.token!;
    }

    if (_token.isEmpty) {
      headers = {"Content-Type": "application/json; charset=utf-8"};
    } else {
      headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer " + _token,
      };
    }
    return headers;
  }

  Future<List<AvaliacaoModel>> buscarAvaliacoesPorDogwalker(
      int dogwalkerId) async {
    try {
      var url = Uri.parse(
        _endpointApi + "/api/v1/avaliacao/dogwalker/$dogwalkerId",
      );
      var response = await _client.get(url, headers: await this.headers());

      if (response.statusCode == 200) {
        List<AvaliacaoModel> avaliacoes = (jsonDecode(response.body) as List)
            .map((data) => AvaliacaoModel.fromJson(data))
            .toList();

        return avaliacoes;
      } else if (response.statusCode == 402 || response.statusCode == 502) {
        throw ("Ocorreu um problema inesperado.");
      } else {
        ResponseDataModel responseData =
            ResponseDataModel.fromJson(response.body);

        throw (responseData.mensagem);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<AvaliacaoModel> buscarPorId(int id) async {
    try {
      var url = Uri.parse(
        _endpointApi + "/api/v1/avaliacao/passeio/$id",
      );
      var response = await _client.get(url, headers: await this.headers());

      if (response.statusCode == 200) {
        AvaliacaoModel avaliacao =
            AvaliacaoModel.fromJson(jsonDecode(response.body));

        return avaliacao;
      } else if (response.statusCode == 402 || response.statusCode == 502) {
        throw ("Ocorreu um problema inesperado.");
      } else {
        ResponseDataModel responseData =
            ResponseDataModel.fromJson(response.body);

        throw (responseData.mensagem);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<String?> cadastrar(AvaliacaoModel avaliacao) async {
    try {
      var url = Uri.parse(
        _endpointApi + "/api/v1/avaliacao",
      );
      var response = await _client.post(
        url,
        headers: await this.headers(),
        body: jsonEncode(avaliacao),
      );

      if (response.statusCode == 200) {
        return "";
      } else if (response.statusCode == 402 || response.statusCode == 502) {
        throw ("Ocorreu um problema inesperado.");
      } else {
        ResponseDataModel responseData =
            ResponseDataModel.fromJson(response.body);

        throw (responseData.mensagem);
      }
    } catch (e) {
      throw (e);
    }
  }
}

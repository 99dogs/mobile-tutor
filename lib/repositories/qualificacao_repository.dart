import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutor/shared/auth/auth_controller.dart';
import 'package:tutor/shared/constants/endpoint_api.dart';
import 'package:tutor/shared/models/configuracao_horario_model.dart';
import 'package:tutor/shared/models/qualificacao_model.dart';
import 'package:tutor/shared/models/response_data_model.dart';
import 'package:tutor/shared/models/usuario_logado_model.dart';

class QualificacaoRepository {
  final _endpointApi = EndpointApi();
  final _authController = AuthController();
  var _client = http.Client();
  String _token = "";

  Future<Map<String, String>> headers() async {
    var headers = Map<String, String>();
    UsuarioLogadoModel usuario = await _authController.obterSessao();

    if (_token.isEmpty) {
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

  Future<List<QualificacaoModel>> buscarPorDogwalker(int id) async {
    try {
      var url = Uri.parse(
        _endpointApi.urlApi + "/api/v1/qualificacao/dogwalker/" + id.toString(),
      );
      var response = await _client.get(url, headers: await this.headers());

      if (response.statusCode == 200) {
        List<QualificacaoModel> qualificacoes =
            (jsonDecode(response.body) as List)
                .map((data) => QualificacaoModel.fromJson(data))
                .toList();

        return qualificacoes;
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

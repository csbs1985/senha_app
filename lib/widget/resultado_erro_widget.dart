import 'package:flutter/material.dart';
import 'package:senha_app/config/constante_config.dart';
import 'package:senha_app/text/mensagem_text.dart';

class ErroResultadoWidget extends StatelessWidget {
  const ErroResultadoWidget({
    super.key,
    required double altura,
  }) : _altura = altura;

  final double _altura;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: _altura,
      child: const Center(child: MensagemText(texto: RESULTADO_ERRO)),
    );
  }
}

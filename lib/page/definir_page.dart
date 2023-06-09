import 'package:flutter/material.dart';
import 'package:senha_app/appbar/voltar_appbar.dart';
import 'package:senha_app/button/toggle_button.dart';
import 'package:senha_app/class/usuario_class.dart';
import 'package:senha_app/config/constante_config.dart';
import 'package:senha_app/config/value_notifier_config.dart';
import 'package:senha_app/model/usuario_model.dart';
import 'package:senha_app/text/subtitulo_text.dart';

class DefinirPage extends StatefulWidget {
  const DefinirPage({super.key});

  @override
  State<DefinirPage> createState() => _DefinicoesPageState();
}

class _DefinicoesPageState extends State<DefinirPage> {
  final UsuarioClass _usuarioClass = UsuarioClass();

  bool _isBiometria = false;

  @override
  void initState() {
    setState(() => _isBiometria = currentUsuario.value.biometria);
    super.initState();
  }

  void _definirBiometria(BuildContext context) {
    setState(() => _isBiometria = !_isBiometria);
    _usuarioClass.toogleBiometria(context, _isBiometria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoltarAppbar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SubtituloText(texto: DEFINIR),
              const SizedBox(height: 24),
              ValueListenableBuilder(
                valueListenable: currentUsuario,
                builder: (BuildContext context, UsuarioModel usuario, _) {
                  return ToggleButton(
                    subtitulo: MODO_ENTRADA,
                    texto: MODO_ENTRADA_DESCRICAO,
                    callback: (value) => _definirBiometria(context),
                    value: _isBiometria,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

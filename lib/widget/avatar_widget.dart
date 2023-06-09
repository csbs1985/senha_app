import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:senha_app/config/value_notifier_config.dart';
import 'package:senha_app/theme/ui_imagem.dart';
import 'package:senha_app/theme/ui_tamanho.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({
    super.key,
    String? avatar,
    double? size = UiTamanho.avatar,
  })  : _avatar = avatar,
        _size = size;

  final String? _avatar;
  final double? _size;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  bool _isImagemAvatar = false;

  Future<void> _vedificarUrl() async {
    try {
      final response = await http.head(
          Uri.parse(widget._avatar ?? currentUsuario.value.avatarUsuario));
      response.statusCode == 200;
      _isImagemAvatar = true;
    } catch (e) {
      _isImagemAvatar = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _vedificarUrl(),
      builder: (BuildContext context, _) {
        return ValueListenableBuilder(
          valueListenable: currentUsuario,
          builder: (BuildContext context, usuario, _) {
            return Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: _isImagemAvatar
                  ? CircleAvatar(
                      radius: widget._size,
                      backgroundImage: NetworkImage(
                          widget._avatar ?? currentUsuario.value.avatarUsuario),
                    )
                  : CircleAvatar(
                      radius: widget._size,
                      backgroundImage: const AssetImage(UiImagem.avatar),
                    ),
            );
          },
        );
      },
    );
  }
}

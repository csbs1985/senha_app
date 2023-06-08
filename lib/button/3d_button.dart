import 'package:flutter/material.dart';
import 'package:senha_app/theme/ui_borda.dart';
import 'package:senha_app/theme/ui_cor.dart';
import 'package:senha_app/theme/ui_tamanho.dart';
import 'package:senha_app/theme/ui_texto.dart';

class Button3dWidget extends StatefulWidget {
  const Button3dWidget({
    super.key,
    required Function callback,
    required String texto,
  })  : _callback = callback,
        _texto = texto;

  final Function _callback;
  final String _texto;

  @override
  State<Button3dWidget> createState() => _Button3dWidgetState();
}

class _Button3dWidgetState extends State<Button3dWidget> {
  final double _height = UiTamanho.botao;

  double _widtht = 0;

  late double _position = UiTamanho.botaoBorda;

  @override
  Widget build(BuildContext context) {
    _widtht = MediaQuery.sizeOf(context).width - (2 * 16);

    return GestureDetector(
      child: SizedBox(
        width: _widtht,
        height: _height + UiTamanho.botaoBorda,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: _widtht,
                height: _height,
                decoration: const BoxDecoration(
                  color: UiCor.terceira,
                  borderRadius: BorderRadius.all(
                    Radius.circular(UiBorda.arredondada),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: _position,
              duration: const Duration(milliseconds: 10),
              child: Container(
                width: _widtht,
                height: _height,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: UiCor.segunda,
                  borderRadius: BorderRadius.all(
                    Radius.circular(UiBorda.arredondada),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget._texto,
                    style: UiTexto.botao,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTapUp: (_) {
        setState(() {
          _position = UiTamanho.botaoBorda;
          widget._callback(true);
        });
      },
      onTapDown: (_) {
        setState(() => _position = 0);
      },
      onTapCancel: () {
        setState(() => _position = UiTamanho.botaoBorda);
      },
    );
  }
}
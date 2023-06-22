import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:senha_app/button/floating_button.dart';
import 'package:senha_app/button/icone_button.dart';
import 'package:senha_app/class/categoria_class.dart';
import 'package:senha_app/class/senha_class.dart';
import 'package:senha_app/class/toast_class.dart';
import 'package:senha_app/config/constante_config.dart';
import 'package:senha_app/config/value_notifier_config.dart';
import 'package:senha_app/firestore/categoria_firestore.dart';
import 'package:senha_app/firestore/senha_firestore.dart';
import 'package:senha_app/mixin/validator_mixin.dart';
import 'package:senha_app/modal/categoria_modal.dart';
import 'package:senha_app/modal/copiar_modal.dart';
import 'package:senha_app/theme/ui_cor.dart';
import 'package:senha_app/widget/editado_widget.dart';
import 'package:senha_app/widget/formulario_input.dart';
import 'package:senha_app/modal/gerar_senha_modal.dart';
import 'package:senha_app/widget/lista_categoria_modal_widget.dart';
import 'package:unicons/unicons.dart';
import 'package:uuid/uuid.dart';

class SenhaPage extends StatefulWidget {
  const SenhaPage({
    super.key,
    required String idSenha,
  }) : _idSenha = idSenha;

  final String _idSenha;

  @override
  State<SenhaPage> createState() => _SenhaPageState();
}

class _SenhaPageState extends State<SenhaPage> with ValidatorMixin {
  final CategoriaClass _categoriaClass = CategoriaClass();
  final CategoriaFirestore _categoriaFirestore = CategoriaFirestore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SenhaClass _senhaClass = SenhaClass();
  final SenhaFirestore _senhaFirestore = SenhaFirestore();
  final ToastClass _toastClass = ToastClass();
  final Uuid uuid = const Uuid();

  final TextEditingController _controllerAnotacao = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerUsuario = TextEditingController();

  String _anotacao = "";
  String _dataRegistro = "";
  String _idSenha = "";
  String _link = "";
  bool _lixeira = false;
  String _nome = "";
  bool _oculto = false;
  String _senha = "";
  String _usuario = "";
  String _usuarioAtual = "";
  String _dataRegistroAtual = "";
  final List<dynamic> _categorias = [];
  final List<Map<String, dynamic>> _listaCategorias = [];

  final double _espaco = 24;

  @override
  void initState() {
    super.initState();

    if (widget._idSenha != EMPTY) Future(() => iniciarSenha());
  }

  iniciarSenha() async {
    Map<String, dynamic>? data;

    await _senhaFirestore.receberSenhaId(widget._idSenha).then((document) => {
          data = document.data() as Map<String, dynamic>,
          setState(() {
            _controllerAnotacao.text = _anotacao = data!['anotacao'];
            _dataRegistro = _dataRegistroAtual = data!['dataRegistro'];
            _idSenha = data!['idSenha'];
            _controllerLink.text = _link = data!['link'];
            _lixeira = data!['lixeira'];
            _controllerNome.text = _nome = data!['nome'];
            _oculto = data!['oculto'];
            _controllerSenha.text = _senha = _usuarioAtual = data!['senha'];
            _controllerUsuario.text = _usuario = data!['usuario'];
          }),
          _definirCategorias(data!['categoria']),
        });
  }

  _definirCategorias(List<dynamic> categorias) {
    Map<String, dynamic>? categoria;

    for (var item in categorias) {
      _categoriaFirestore.receberCategoriaId(item).then((result) => {
            categoria = result.data() as Map<String, dynamic>,
            setState(() => _listaCategorias.add(categoria!)),
          });
    }
  }

  void _abrirCategoriaModal() {
    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      barrierColor: UiCor.overlay,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) => const CategoriaModal(),
    );
  }

  toggleOculto() {
    setState(() => _oculto = !_oculto);

    _toastClass.sucesso(
      context: context,
      texto: _oculto ? SENHA_OCULTA : SENHA_NAO_OCULTA,
    );
  }

  void _modalCopiar(BuildContext context) {
    Map<String, dynamic> _copiar = {
      'anotacao': _anotacao,
      'link': _link,
      'nome': _nome,
      'senha': _senha,
      'usuario': _usuario
    };

    showCupertinoModalBottomSheet(
      context: context,
      barrierColor: UiCor.overlay,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) => CopiarModal(copiar: _copiar),
    );
  }

  floatingActionButton(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic>? form;
      setState(() {
        if (widget._idSenha != EMPTY) {
          //editar
          form = {
            "anotacao": _controllerAnotacao.text,
            "categorias": _categorias,
            "dataRegistro": _usuarioAtual == _senha
                ? _dataRegistroAtual
                : DateTime.now().toString(),
            "idSenha": _idSenha,
            "idUsuario": currentUsuario.value.idUsuario,
            "link": _controllerLink.text,
            "lixeira": _lixeira,
            "nome": _nome,
            "oculto": _oculto,
            "senha": _senha,
            "usuario": _controllerUsuario.text,
          };
        } else {
          // criar
          form = {
            "anotacao": _controllerAnotacao.text,
            "categorias": _categorias,
            "dataRegistro": DateTime.now().toString(),
            "idSenha": uuid.v4(),
            "idUsuario": currentUsuario.value.idUsuario,
            "link": _controllerLink.text,
            "lixeira": false,
            "nome": _nome,
            "oculto": _oculto,
            "senha": _controllerSenha.text,
            "usuario": _controllerUsuario.text,
          };
        }
      });

      _senhaClass.salvarSenha(context, form!);
    }
  }

  _modalGerador(BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      barrierColor: UiCor.overlay,
      backgroundColor: Colors.red,
      builder: (context) => GerarSenhaModal(
        callback: (value) => {
          Navigator.of(context).pop(),
          setState(() => _controllerSenha.text = _senha = value),
        },
      ),
    );
  }

  bool _verificarCopiar() {
    if (_anotacao != "" ||
        _link != "" ||
        _nome != "" ||
        _senha != "" ||
        _usuario != "") return true;

    return false;
  }

  @override
  void dispose() {
    _controllerAnotacao.dispose();
    _controllerLink.dispose();
    _controllerNome.dispose();
    _controllerSenha.dispose();
    _controllerUsuario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconeButton(
          icone: UniconsLine.arrow_left,
          callback: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_verificarCopiar())
            IconeButton(
              icone: UniconsLine.copy,
              callback: () => _modalCopiar(context),
            ),
          if (_dataRegistro != "")
            IconeButton(
              icone: UniconsLine.trash_alt,
              callback: () =>
                  _senhaClass.senhaDeletadaTrue(context, widget._idSenha),
            ),
          IconeButton(
            icone: UniconsLine.asterisk,
            callback: () => _modalGerador(context),
          ),
          IconeButton(
            icone: _oculto ? UniconsLine.toggle_on : UniconsLine.toggle_off,
            callback: () => toggleOculto(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormularioInput(
                  controller: _controllerNome,
                  callback: (value) => setState(() => _nome = value),
                  hintText: NOME,
                  validator: (value) => inNotEmpty(value),
                ),
                SizedBox(height: _espaco),
                FormularioInput(
                  controller: _controllerLink,
                  callback: (value) => setState(() => _link = value),
                  hintText: LINK,
                  validator: (value) => regexUrl(value!),
                ),
                SizedBox(height: _espaco),
                FormularioInput(
                  controller: _controllerUsuario,
                  callback: (value) => setState(() => _usuario = value),
                  hintText: USUARIO,
                ),
                SizedBox(height: _espaco),
                FormularioInput(
                  controller: _controllerSenha,
                  callback: (value) => setState(() => _senha = value),
                  hintText: SENHA,
                  validator: (value) => combinarValidacao([
                    () => inNotEmpty(value),
                    () => isSenhaCaracteres(value!),
                  ]),
                ),
                SizedBox(height: _espaco),
                FormularioInput(
                  controller: _controllerAnotacao,
                  callback: (value) => setState(() => _anotacao = value),
                  hintText: ANOTACAO,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: ListaCategoriaModalWidget(
                    listaCategorias: _listaCategorias,
                    callback: () => _abrirCategoriaModal(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: EditadoWidget(dataRegistro: _dataRegistro),
      floatingActionButton: FloatingButton(
        callback: () => floatingActionButton(context),
        icone: UniconsLine.check,
      ),
    );
  }
}

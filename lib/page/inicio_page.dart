import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:senha_app/class/routes_class.dart';
import 'package:senha_app/class/usuario_class.dart';
import 'package:senha_app/config/constante_config.dart';
import 'package:senha_app/firestore/senha_firestore.dart';
import 'package:senha_app/page/drawer_page.dart';
import 'package:senha_app/skeleton/senha_item_skeleton.dart';
import 'package:senha_app/text/titulo_text.dart';
import 'package:senha_app/theme/ui_borda.dart';
import 'package:senha_app/theme/ui_tamanho.dart';
import 'package:senha_app/widget/avatar_widget.dart';
import 'package:senha_app/widget/resultado_erro_widget.dart';
import 'package:senha_app/widget/padrao_input.dart';
import 'package:senha_app/widget/resultado_vazio_widget.dart';
import 'package:senha_app/widget/senha_item_widget.dart';
import 'package:unicons/unicons.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final SenhaFirestore _senhaFirestore = SenhaFirestore();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    double altura = MediaQuery.sizeOf(context).height - (UiTamanho.appbar * 4);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const DrawerPage(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 88),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TituloText(texto: SENHA),
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                        child: const AvatarWidget(),
                      ),
                    ],
                  ),
                ),
                FirestoreListView(
                  query: _senhaFirestore
                      .getTodasSenhasUsuario(currentUsuario.value.idUsuario),
                  pageSize: 30,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  loadingBuilder: (context) => const SenhaItemSkeleton(),
                  errorBuilder: (context, error, _) =>
                      ErroResultadoWidget(altura: altura),
                  emptyBuilder: (context) =>
                      ResultadoVazioWidget(altura: altura),
                  itemBuilder: (
                    BuildContext context,
                    QueryDocumentSnapshot<dynamic> snapshot,
                  ) {
                    Map<String, dynamic> senha = snapshot.data();

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: SenhaItemWidget(senha: senha),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: PadraoInput(
              callback: (value) => {},
              hintText: PESQUISAR,
              pesquisar: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RoutesEnum.SENHA.value,
            pathParameters: {'idSenha': EMPTY}),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiBorda.arredondada)),
        child: const Icon(UniconsLine.plus),
      ),
    );
  }
}

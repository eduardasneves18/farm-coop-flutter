// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:generics_components_flutter/generics_components_flutter.dart';
// import 'package:provider/provider.dart';
// // import 'package:yes_bank/components/fields/yb_text_field.dart';
// // import 'package:yes_bank/models/cliente.dart';
// // import 'package:yes_bank/screens/signout/register/register.dart';
// // import 'package:yes_bank/services/firebase/sessions/sessionManager.dart';
// // import 'package:yes_bank/store/cliente_store.dart';
//
// // import '../../../components/dialogs/yb_dialog_message.dart';
// // import '../../../components/fields/yb_password_field.dart';
// // import '../../../services/firebase/login/login_firebase.dart';
// // import '../../home/home_dashboard.dart';
//
// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _senhaController = TextEditingController();
// // final LoginFirebaseAuthService _loginFirebaseService = LoginFirebaseAuthService();
//
// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryData data = MediaQuery.of(context);
//     final Size sizeScreen = data.size;
//
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//            // color: Color(0xFF4C7031),
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF4C7031),
//               Color(0xFF395229),
//             ],
//           ),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: 15.0,
//           vertical: sizeScreen.width * 0.05,
//         ),
//         width: sizeScreen.width,
//         height: sizeScreen.height,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Welcome(sizeScreen: sizeScreen),
//               GestureDetector(
//                 child: Form(sizeScreen: sizeScreen),
//                 onTap: () => FocusScope.of(context).unfocus(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Welcome extends StatelessWidget {
//   final Size sizeScreen;
//
//   const Welcome({Key? key, required this.sizeScreen}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Text(
//             'FarmCoop',
//             style: TextStyle(
//               fontSize: sizeScreen.width * 0.08,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFF4F1EE),
//             ),
//           ),
//           Text(
//             'Faça seu login para continuar',
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class Form extends StatelessWidget {
//   final Size sizeScreen;
//
//   const Form({Key? key, required this.sizeScreen}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // final ClienteStore _clienteStore = Provider.of<ClienteStore>(context);
//     return Container(
//       margin: EdgeInsets.only(top: sizeScreen.width * 0.05),
//       child: Column(
//         children: <Widget>[
//           TextFields(
//             controller: _emailController,
//             sizeScreen: sizeScreen,
//             icon: Icons.mail_outline,
//             hint: 'E-mail',
//             borderColor: Colors.black,
//             textColor: Colors.grey,
//             cursorColor: Colors.black,
//             fillColor: Colors.transparent,
//             labelColor: Colors.white,
//             security: null,
//           ),
//           PasswordField(
//             controller: _senhaController,
//             sizeScreen: sizeScreen,
//             icon: Icons.lock_outline,
//             hint: 'Senha',
//             borderColor: Colors.black,
//             textColor: Colors.grey,
//             cursorColor: Colors.black,
//             fillColor: Colors.transparent,
//             security: true,
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//                 vertical: sizeScreen.height * 0.01,
//                 horizontal: sizeScreen.height * 0.025),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 RichText(
//                   text: TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Ainda não possui uma conta? ',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'Cadastre-se',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.yellow,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                           print("object");
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(builder: (context) => Register()),
//                             // );
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: sizeScreen.height * 0.03),
//             child: SizedBox(
//               width: sizeScreen.width * 0.70,
//               height: sizeScreen.width * 0.12,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF004D61),
//                   foregroundColor: Colors.grey[100],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18.0),
//                   ),
//                 ),
//                 child: Text(
//                   'Entrar',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () async {
//                   String email = _emailController.text.trim();
//                   String senha = _senhaController.text.trim();
//
//                   if (email.isEmpty) {
//                     DialogMessage.showMessage(
//                       context: context,
//                       title: 'Erro',
//                       message: 'Por favor, digite seu e-mail.',
//                     );
//                     return;
//                   }
//
//                   if (senha.isEmpty) {
//                     DialogMessage.showMessage(
//                       context: context,
//                       title: 'Erro',
//                       message: 'Por favor, digite sua senha.',
//                     );
//                     return;
//                   }
//
//                   try {
//                     // User? user = await _loginFirebaseService.signInWithEmailPassword(email, senha, _clienteStore);
//                     //
//                     // if (user?.uid != null){
//                     //   Cliente cliente = Cliente(id: user?.uid, email: user?.email, nome: user?.displayName, password: null, primeiroNome: null, ultimoNome: null);
//                     //   SessionManager sessionmanager = SessionManager(_loginFirebaseService, cliente, _clienteStore);
//                     // }
//
// print("object");
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => HomeDashboard(),
//                     //   ),
//                     // );
//                   } catch (e) {
//                     DialogMessage.showMessage(
//                       context: context,
//                       title: 'Erro',
//                       message: 'Falha ao realizar o login. Tente novamente.',
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _senhaController = TextEditingController();

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Icon(Icons.agriculture, size: 80, color: const Color(0xFF4CAF50)),
                      const SizedBox(height: 16),
                      Text(
                        'FarmCoop',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Faça seu login para continuar',
                        style: TextStyle(color: Color(0xFFD5C1A1)),
                      ),
                      const SizedBox(height: 40),

                      TextFields(
                        controller: _emailController,
                        sizeScreen: MediaQuery.of(context).size,
                        icon: Icons.email_outlined,
                        hint: 'E-mail',
                        hintColor: Color(0xFFD5C1A1),
                        iconColor: Color(0xFFD5C1A1),
                        borderColor: const Color(0xFF4CAF50),
                        textColor: Color(0xFFD5C1A1),
                        cursorColor: const Color(0xFF4CAF50),
                        fillColor: Color(0xFF121212),
                        labelColor: const Color(0xFF4CAF50),
                        security: null,
                      ),
                      const SizedBox(height: 20),

                      PasswordField(
                        controller: _senhaController,
                        sizeScreen: MediaQuery.of(context).size,
                        icon: Icons.lock_outline,
                        hint: 'Senha',
                        hintColor: Color(0xFFD5C1A1),
                        iconColor: Color(0xFFD5C1A1),
                        borderColor: const Color(0xFF4CAF50),
                        textColor: Color(0xFFD5C1A1),
                        cursorColor: const Color(0xFF4CAF50),
                        fillColor: Color(0xFF121212),
                        labelColor: const Color(0xFF4CAF50),
                        security: true,
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: 'Ainda não possui uma conta? ',
                            style: const TextStyle(color: Color(0xFFD5C1A1)),
                            children: [
                              TextSpan(
                                text: 'Cadastre-se',
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("Cadastro clicado");
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final email = _emailController.text.trim();
                            final senha = _senhaController.text.trim();

                            if (email.isEmpty || senha.isEmpty) {
                              DialogMessage.showMessage(
                                context: context,
                                title: 'Erro',
                                message: 'Por favor, preencha e-mail e senha.',
                              );
                              return;
                            }

                            print('Login com: $email');
                          },
                          label: const Text('Entrar'),
                          icon: const Icon(Icons.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E513F),
                            foregroundColor: const Color(0xFFE8E3D4),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


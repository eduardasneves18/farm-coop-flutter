import 'package:coop_farm/screens/signout/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../services/firebase/sessions/sessionManager.dart';
import '../../services/firebase/users/login/login_firebase.dart';
import '../../store/cliente_store.dart';
import '../home/home.dart'; // <-- Change this to your actual home screen after login

final TextEditingController _emailController = TextEditingController();
final TextEditingController _senhaController = TextEditingController();
final LoginFirebaseAuthService _loginFirebaseService = LoginFirebaseAuthService();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;
    final ClienteStore _clienteStore = Provider.of<ClienteStore>(context, listen: false);

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
                      const Icon(Icons.agriculture, size: 80, color: Color(0xFF3E513F)),
                      const SizedBox(height: 16),
                      Text(
                        'FarmCoop',
                        style: TextStyle(
                          fontSize: sizeScreen.width * 0.08,
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

                      // Email Field
                      TextFields(
                        controller: _emailController,
                        sizeScreen: sizeScreen,
                        icon: Icons.email_outlined,
                        hint: 'E-mail',
                        hintColor: Color(0xFFD5C1A1),
                        iconColor: Color(0xFFD5C1A1),
                        borderColor: Color(0xFF4CAF50),
                        textColor: Color(0xFFD5C1A1),
                        cursorColor: Color(0xFF4CAF50),
                        fillColor: Color(0xFF121212),
                        labelColor: Color(0xFF4CAF50),
                        security: null,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      PasswordField(
                        controller: _senhaController,
                        sizeScreen: sizeScreen,
                        icon: Icons.lock_outline,
                        hint: 'Senha',
                        hintColor: Color(0xFFD5C1A1),
                        iconColor: Color(0xFFD5C1A1),
                        borderColor: Color(0xFF4CAF50),
                        textColor: Color(0xFFD5C1A1),
                        cursorColor: Color(0xFF4CAF50),
                        fillColor: Color(0xFF121212),
                        labelColor: Color(0xFF4CAF50),
                        security: true,
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Navigation
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserRegister(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
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

                            try {
                              User? user = await _loginFirebaseService.signInWithEmailPassword(
                                email,
                                senha,
                                _clienteStore,
                              );

                              if (user != null && user.uid.isNotEmpty) {
                                final cliente = Cliente(
                                  id: user.uid,
                                  email: user.email,
                                  nome: user.displayName,
                                  password: null,
                                  primeiroNome: null,
                                  ultimoNome: null,
                                );

                                final sessionManager = SessionManager(
                                  _loginFirebaseService,
                                  cliente,
                                  _clienteStore,
                                );

                                // Navigate to home/dashboard screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              } else {
                                throw Exception("Usuário inválido.");
                              }
                            } catch (e) {
                              DialogMessage.showMessage(
                                context: context,
                                title: 'Erro',
                                message: 'Falha ao realizar o login. Tente novamente.',
                              );
                            }
                          },
                          label: const Text('Entrar'),
                          icon: const Icon(Icons.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Color(0xFFE8E3D4),
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

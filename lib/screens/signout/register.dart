import 'package:coop_farm/screens/home/home.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import 'package:flutter/material.dart';
import '../../services/firebase/users/user_firebase.dart';
import 'login.dart';

class UserRegister extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<UserRegister> {
  final UsersFirebaseService _userFirebaseService = UsersFirebaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final Size sizeScreen = media.size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF121212),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFF000000),
          //     Color(0xFF666666),
          //   ],
          // ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: sizeScreen.width * 0.05,
        ),
        width: sizeScreen.width,
        height: sizeScreen.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Welcome(sizeScreen: sizeScreen),
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: RegisterForm(
                  sizeScreen: sizeScreen,
                  usersFirebaseService: _userFirebaseService,
                  nameController: _nameController,
                  emailController: _emailController,
                  passController: _passController,
                  confirmPassController: _confirmPassController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  final Size sizeScreen;

  const Welcome({Key? key, required this.sizeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'FarmCoop',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.08,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4CAF50),
          ),
        ),
        Text(
          'Cadastro',
          style: TextStyle(
            color: Color(0xFFD5C1A1),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  final Size sizeScreen;
  final UsersFirebaseService usersFirebaseService;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController confirmPassController;

  const RegisterForm({
    Key? key,
    required this.sizeScreen,
    required this.usersFirebaseService,
    required this.nameController,
    required this.emailController,
    required this.passController,
    required this.confirmPassController,
  }) : super(key: key);

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {TextInputType textType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: TextFields(
        controller: controller,
        labelColor: Color(0xFF4CAF50),
        sizeScreen: sizeScreen,
        iconColor: Color(0xFFD5C1A1),
        hint: hint,
        hintColor: Color(0xFFD5C1A1),
        fillColor: Colors.transparent,
        cursorColor: Colors.white,
        textType: textType,
        borderColor: Color(0xFF4CAF50),
        textColor: Color(0xFFD5C1A1),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: PasswordField(
        controller: controller,
        hint: hint,
        sizeScreen: sizeScreen,
        labelColor: Color(0xFF4CAF50),
        icon: Icons.lock_outline,
        iconColor: Color(0xFFD5C1A1),
        hintColor: Color(0xFFD5C1A1),
        fillColor: Colors.transparent,
        cursorColor: Colors.white,
        borderColor: Color(0xFF4CAF50),
        textColor: Color(0xFFD5C1A1),
        textType: TextInputType.visiblePassword,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: sizeScreen.width * 0.02),
      child: SizedBox(
        width: sizeScreen.width * 0.90,
        height: sizeScreen.width * 0.12,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3E513F),
            foregroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          child: Text(
            'Cadastrar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            String email = emailController.text.trim();
            String senha = passController.text.trim();
            String confirmSenha = confirmPassController.text.trim();
            String name = nameController.text.trim();

            if (name.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite seu nome.');
              return;
            }

            if (email.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite seu e-mail.');
              return;
            }

            if (senha.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite sua senha.');
              return;
            }

            if (confirmSenha.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, confirme sua senha.');
              return;
            }

            if (senha != confirmSenha) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'As senhas não coincidem.');
              return;
            }

            try {
              await usersFirebaseService.createUser(name, email, senha);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } catch (e) {
              DialogMessage.showMessage(
                  context: context, title: 'Erro', message: 'Falha ao criar o usuário. Tente novamente.');
            }
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(top: sizeScreen.width * 0.05, left: 15.0),
        child: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: sizeScreen.width * 0.12,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(nameController, 'Nome', Icons.person),
        _buildTextField(emailController, 'E-mail', Icons.email, textType: TextInputType.emailAddress),
        _buildPasswordField(passController, 'Senha'),
        _buildPasswordField(confirmPassController, 'Confirmar senha'),
        _buildRegisterButton(context),
        _buildBackButton(context),
      ],
    );
  }
}

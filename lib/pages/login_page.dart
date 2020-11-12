import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/blue_button.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/helpers/show_alert.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            
            Logo(title: 'Messenger'),
            
            _Form(),
            
            Labels(
              primaryText: '¿No tienes cuenta?',
              secondaryText: 'Crea una ahora!',
              toRoute: 'register'
            ),

            Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w300),),
            //SizedBox(height: 1)

          ],
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passwdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInputField(
            icon: Icons.mail_outline,
            placeholder: 'E-mail',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInputField(
            icon: Icons.lock,
            placeholder: 'Password',
            keyboardType: TextInputType.text,
            textController: passwdCtrl,
            isPassword: true,
          ),
          
          BlueButton(
            onPressed: authService.onProcessing ? null : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailCtrl.text.trim(), passwdCtrl.text.trim());
              if(loginOk){

                Navigator.pushReplacementNamed(context, 'users');

              }
              else {
                showAlert(context, 'Error', 'Falló el inicio de sesión');
              }
            },
            text: 'Ingrese',
          ),
          
        ],
      ),
    );
  }
}




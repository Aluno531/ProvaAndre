import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool loading = false;

 void register() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  // validação de no mínimo 6 caracteres (como o firebase pede) 
  if (password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('A senha deve ter no mínimo 6 caracteres.')),
    );
    return;
  }

  setState(() => loading = true);

  String? result = await auth.register(email, password);

  setState(() => loading = false);

  if (result == null) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conta criada com sucesso!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar Conta")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}

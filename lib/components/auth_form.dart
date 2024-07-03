import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';

import '../models/auth.dart';

enum AuthMode {
  signup,
  login,
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  AuthMode authmode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool get _isLogin => authmode == AuthMode.login;
  bool get _isSignup => authmode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin) {
        authmode = AuthMode.signup;
      } else {
        authmode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin) {
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        await auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (err) {
      _showErrorDialog(err.toString());
    } catch (err) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        height: _isLogin ? 310 : 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onSaved: (value) => _authData['email'] = value ?? '',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value ?? '';

                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (value) => _authData['password'] = value ?? '',
                  validator: (value) {
                    final password = value ?? '';

                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha válida';
                    }

                    return null;
                  }),
              if (_isSignup)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: (value) {
                    final password = value ?? '';

                    if (password != _passwordController.text) {
                      return 'Senha não confere';
                    }

                    return null;
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    )),
                  ),
                  child: Text(_isLogin ? 'ENTRAR' : 'CADASTRAR'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_isLogin ? 'Deseja registrar?' : 'Já possui conta'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/cartao_formulario.dart';
import '../components/logo_coma_bem.dart';
import '../components/rodape_manuscrito.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'cadastro_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final usuario = await DatabaseHelper.instancia.autenticarUsuario(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha inválidos!'),
          backgroundColor: AppColors.erro,
        ),
      );
    }
  }

  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroUsuarioScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const LogoComaBem(largura: 140),
                      const SizedBox(height: 16),
                      CartaoFormulario(
                        titulo: 'Acesse sua conta',
                        children: [
                          CampoFormularioCustomizado(
                            titulo: 'E-mail',
                            controlador: _emailController,
                            tipoTeclado: TextInputType.emailAddress,
                            icone: Icons.mail_outline_rounded,
                            dica: 'exemplo@email.com',
                            validador: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return 'Informe seu e-mail';
                              }
                              if (!valor.contains('@') ||
                                  !valor.contains('.')) {
                                return 'Informe um e-mail válido';
                              }
                              return null;
                            },
                          ),
                          CampoFormularioCustomizado(
                            titulo: 'Senha',
                            controlador: _senhaController,
                            ocultarTexto: !_senhaVisivel,
                            icone: Icons.lock_outline_rounded,
                            dica: 'Sua senha de acesso',
                            espacoInferior: 0,
                            sufixo: IconButton(
                              icon: Icon(
                                _senhaVisivel
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.icone,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(
                                    () => _senhaVisivel = !_senhaVisivel);
                              },
                            ),
                            validador: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return 'Informe sua senha';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _carregando ? null : _fazerLogin,
                        child: _carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            RodapeManuscrito(
              pergunta: 'Ainda não tem conta?',
              acao: 'Cadastre-se',
              onTap: _irParaCadastro,
            ),
          ],
        ),
      ),
    );
  }
}

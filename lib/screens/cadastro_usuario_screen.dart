import 'package:flutter/material.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/cartao_formulario.dart';
import '../components/logo_coma_bem.dart';
import '../components/rodape_manuscrito.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _criarConta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final erro = await DatabaseHelper.instancia.cadastrarUsuario(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! Faça login para continuar.'),
          backgroundColor: AppColors.sucesso,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: AppColors.erro),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(),
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
                      const LogoComaBem(largura: 120),
                      const SizedBox(height: 16),
                      CartaoFormulario(
                        titulo: 'Crie sua conta',
                        children: [
                          CampoFormularioCustomizado(
                            titulo: 'Nome completo',
                            controlador: _nomeController,
                            icone: Icons.person_outline_rounded,
                            dica: 'Seu nome',
                            validador: (valor) =>
                                (valor == null || valor.trim().isEmpty)
                                    ? 'Informe seu nome'
                                    : null,
                          ),
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
                            dica: 'Mínimo de 6 caracteres',
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
                                return 'Crie uma senha';
                              }
                              if (valor.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _carregando ? null : _criarConta,
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
                            : const Text('Criar conta'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            RodapeManuscrito(
              pergunta: 'Já tem uma conta?',
              acao: 'Entrar',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

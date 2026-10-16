import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/cartao_formulario.dart';
import '../theme/app_theme.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();
  final TextEditingController _pratoController = TextEditingController();

  File? _fotoPrato;
  bool _salvando = false;

  final String _latitude = '';
  final String _longitude = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nomeController.dispose();
    _culinariaController.dispose();
    _pratoController.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada =
        await _picker.pickImage(source: ImageSource.camera);

    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }

  Future<void> _salvarCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final dadosRestaurante = {
        'res_nm_restaurante': _nomeController.text.trim(),
        'res_ds_tipo_culinaria': _culinariaController.text.trim(),
        'res_nu_latitude': _latitude,
        'res_nu_longitude': _longitude,
      };

      // BUG CORRIGIDO: o restaurante era salvo, mas o prato informado no
      // formulário nunca era gravado no banco. Agora usamos o ID gerado
      // do restaurante para also salvar o prato vinculado a ele.
      final idRestaurante = await DatabaseHelper.instancia
          .inserirDados('restaurante', dadosRestaurante);

      if (_pratoController.text.trim().isNotEmpty) {
        await DatabaseHelper.instancia.inserirDados('prato', {
          'pra_nm_prato': _pratoController.text.trim(),
          'pra_im_foto': _fotoPrato?.path,
          'pra_id_restaurante': idRestaurante,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurante cadastrado com sucesso!'),
          backgroundColor: AppColors.sucesso,
        ),
      );

      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado ao salvar.'),
          backgroundColor: AppColors.erro,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(title: const Text('Novo restaurante')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartaoFormulario(
                  titulo: 'Dados do restaurante',
                  children: [
                    CampoFormularioCustomizado(
                      titulo: 'Nome do restaurante',
                      controlador: _nomeController,
                      icone: Icons.storefront_outlined,
                      dica: 'Ex.: Cantina da Nonna',
                      obrigatorio: true,
                    ),
                    CampoFormularioCustomizado(
                      titulo: 'Tipo de culinária',
                      controlador: _culinariaController,
                      icone: Icons.restaurant_menu_outlined,
                      dica: 'Ex.: Italiana',
                      obrigatorio: true,
                      espacoInferior: 0,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CartaoFormulario(
                  titulo: 'Prato em destaque (opcional)',
                  children: [
                    CampoFormularioCustomizado(
                      titulo: 'Nome do prato',
                      controlador: _pratoController,
                      icone: Icons.ramen_dining_outlined,
                      dica: 'Ex.: Lasanha à bolonhesa',
                    ),
                    const Text(
                      'Foto do prato',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _tirarFoto,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.fundo,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borda, width: 1),
                          image: _fotoPrato != null
                              ? DecorationImage(
                                  image: FileImage(_fotoPrato!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _fotoPrato == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined,
                                      color: AppColors.roxo, size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    'Toque para tirar uma foto',
                                    style: TextStyle(
                                      color: AppColors.textoSecundario,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.black.withValues(alpha: 0.55),
                                    radius: 16,
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvando ? null : _salvarCadastro,
                  child: _salvando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

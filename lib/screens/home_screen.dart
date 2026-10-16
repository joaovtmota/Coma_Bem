import 'package:flutter/material.dart';
import '../components/titulo_coma_bem.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _restaurantes = [];
  List<Map<String, dynamic>> _restaurantesFiltrados = [];
  bool _carregando = true;
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  Future<void> _carregarRestaurantes() async {
    setState(() => _carregando = true);
    final dados = await DatabaseHelper.instancia.consultarDados('restaurante');
    if (!mounted) return;
    setState(() {
      _restaurantes = dados;
      _aplicarFiltro();
      _carregando = false;
    });
  }

  void _aplicarFiltro() {
    if (_termoBusca.trim().isEmpty) {
      _restaurantesFiltrados = _restaurantes;
    } else {
      final termo = _termoBusca.toLowerCase();
      _restaurantesFiltrados = _restaurantes.where((res) {
        final nome = (res['res_nm_restaurante'] ?? '').toString().toLowerCase();
        final tipo =
            (res['res_ds_tipo_culinaria'] ?? '').toString().toLowerCase();
        return nome.contains(termo) || tipo.contains(termo);
      }).toList();
    }
  }

  IconData _iconePorCulinaria(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'japonesa':
        return Icons.set_meal_outlined;
      case 'italiana':
        return Icons.local_pizza_outlined;
      case 'brasileira':
        return Icons.outdoor_grill_outlined;
      case 'francesa':
        return Icons.restaurant_menu_outlined;
      case 'mexicana':
        return Icons.local_dining_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  Future<void> _abrirCadastro() async {
    // BUG CORRIGIDO: a lista não era recarregada ao voltar do
    // cadastro, então o restaurante recém-criado só aparecia
    // depois de reiniciar o app.
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );
    if (resultado == true) {
      _carregarRestaurantes();
    }
  }

  /// Botão "Novo restaurante" do canto superior direito. Em telas largas
  /// (computador/tablet) mostra o texto; em telas estreitas (celular)
  /// mostra só o "+", para não colidir com o título centralizado.
  Widget _buildBotaoNovo() {
    final telaLarga = MediaQuery.sizeOf(context).width >= 600;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: telaLarga
          ? ElevatedButton.icon(
              onPressed: _abrirCadastro,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Adicionar restaurante'),
              style: ElevatedButton.styleFrom(
                // O tema global usa largura infinita; aqui precisa ser
                // compacto para caber na barra do topo.
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
            )
          : IconButton.filled(
              onPressed: _abrirCadastro,
              tooltip: 'Adicionar restaurante',
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.roxo,
                foregroundColor: Colors.white,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        toolbarHeight: 72,
        title: const TituloComaBem(),
        actions: [_buildBotaoNovo()],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.roxo,
          backgroundColor: Colors.white,
          onRefresh: _carregarRestaurantes,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: TextField(
                  onChanged: (valor) {
                    setState(() {
                      _termoBusca = valor;
                      _aplicarFiltro();
                    });
                  },
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: AppColors.textoPrincipal,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Buscar restaurantes ou culinária...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.icone,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _carregando
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.roxo,
                        ),
                      )
                    : _restaurantesFiltrados.isEmpty
                        ? _buildEstadoVazio()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            itemCount: _restaurantesFiltrados.length,
                            itemBuilder: (context, index) {
                              final restaurante = _restaurantesFiltrados[index];
                              return _buildCardRestaurante(restaurante);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    final semResultadoDeBusca =
        _termoBusca.isNotEmpty && _restaurantes.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    semResultadoDeBusca
                        ? Icons.search_off_rounded
                        : Icons.restaurant_outlined,
                    size: 56,
                    color: AppColors.lilas,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    semResultadoDeBusca
                        ? 'Nenhum restaurante encontrado'
                        : 'Nenhum restaurante cadastrado ainda',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    semResultadoDeBusca
                        ? 'Tente buscar por outro nome ou tipo de culinária.'
                        : 'Use o botão "Novo restaurante" no topo para adicionar o primeiro.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardRestaurante(Map<String, dynamic> restaurante) {
    final nome = (restaurante['res_nm_restaurante'] ?? '').toString();
    final tipo = (restaurante['res_ds_tipo_culinaria'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bordaCard, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.roxo.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _iconePorCulinaria(tipo),
                color: AppColors.roxo,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.rosa.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tipo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.roxoEscuro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.icone,
            ),
          ],
        ),
      ),
    );
  }
}

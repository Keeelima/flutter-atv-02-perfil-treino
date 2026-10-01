import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

// Classe MeuApp - Ponto de inicio de preparação dos Widgets
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Montador de Perfil de Treino',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F766E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFBE5B45),
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Color(0xFFBE5B45), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // Aponta Home para Classe AgendamentoEventoTela
      home: const AgendamentoEventoTela(),
    );
  }
}

class AgendamentoEventoTela extends StatefulWidget {
  const AgendamentoEventoTela({super.key});

  @override
  State<AgendamentoEventoTela> createState() => _AgendamentoEventoTelaState();
}

class _AgendamentoEventoTelaState extends State<AgendamentoEventoTela> {
  // --- 1. Valores Padrão (para reset) ---
  static final DateTime _dataPadrao = DateTime.now();
  static const TimeOfDay _horarioPadrao = TimeOfDay(hour: 19, minute: 0);
  static const String _tipoPadrao = 'Emagrecimento';
  static const String _nivelPessoaPadrao = 'iniciante';
  static const int _tempoDiarioPadrao = 60;
  static const int _tempoDiarioMinimo = 15;
  static const int _tempoDiarioMaximo = 120;
  static const int _tempoDiarioIncremento = 5;
  static const List<String> _frequenciasSemanaisDisponiveis = [
    '2 dias por semana',
    '3 dias por semana',
    '4 dias por semana',
    '5 dias por semana',
    '6 dias por semana',
  ];
  static const List<String> _niveisPessoaDisponiveis = [
    'iniciante',
    'intermediario',
    'avançado',
  ];
  static const List<String> _restricoesAlimentaresDisponiveis = [
    'Vegetariano',
    'Vegano',
    'Sem lactose',
    'Sem glúten',
    'Low Carb',
  ];
  static const List<String> _restricoesAlimentaresPadrao = [];
  static const bool _notificacoesAguaPadrao = false;
  static const bool _termosAceitosPadrao = false;

  // --- 2. Variáveis de Estado ---
  DateTime _dataSelecionada = _dataPadrao;
  TimeOfDay _horarioSelecionado = _horarioPadrao;
  String _tipoObjetivoSelecionado = _tipoPadrao;
  String _nivelPessoa = _nivelPessoaPadrao;
  int _tempoDiarioSelecionado = _tempoDiarioPadrao;
  String? _frequenciaSemanalSelecionada;
  final TextEditingController _alergiaController = TextEditingController();
  final FocusNode _alergiaFocusNode = FocusNode();
  List<String> _alergiasSelecionadas = [];
  List<String> _restricoesAlimentaresSelecionadas = List<String>.from(
    _restricoesAlimentaresPadrao,
  );
  bool _notificacoesAguaAtivas = _notificacoesAguaPadrao;
  bool _termosAceitos = _termosAceitosPadrao;

  @override
  void initState() {
    super.initState();
    _aplicarValoresPadrao();
  }

  void _aplicarValoresPadrao() {
    _dataSelecionada = _dataPadrao;
    _horarioSelecionado = _horarioPadrao;
    _tipoObjetivoSelecionado = _tipoPadrao;
    _nivelPessoa = _nivelPessoaPadrao;
    _tempoDiarioSelecionado = _tempoDiarioPadrao;
    _frequenciaSemanalSelecionada = null;
    _alergiasSelecionadas = [];
    _alergiaController.clear();
    _restricoesAlimentaresSelecionadas = List<String>.from(
      _restricoesAlimentaresPadrao,
    );
    _notificacoesAguaAtivas = _notificacoesAguaPadrao;
    _termosAceitos = _termosAceitosPadrao;
  }

  @override
  void dispose() {
    _alergiaController.dispose();
    _alergiaFocusNode.dispose();
    super.dispose();
  }

  void resetarValores() {
    setState(_aplicarValoresPadrao);
    debugPrint('[DEBUG] Formulario resetado para os valores padrao.');
  }

  void gerarPlano() {
    final List<String> erros = [];

    if (_tipoObjetivoSelecionado.trim().isEmpty) {
      erros.add('Objetivo do treino não selecionado');
    }

    if (_nivelPessoa.trim().isEmpty) {
      erros.add('Nível não informado');
    }

    if (_frequenciaSemanalSelecionada == null) {
      erros.add('Frequência semanal não selecionada');
    }

    if (!_termosAceitos) {
      erros.add('Termos não aceitos');
    }

    if (erros.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Corrija antes de gerar o plano:\n• ${erros.join('\n• ')}',
          ),
        ),
      );
      return;
    }

    debugPrint('==============================');
    debugPrint('       RESUMO DO PLANO         ');
    debugPrint('==============================');
    debugPrint(
      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
    );
    debugPrint('Horário: ${_horarioSelecionado.format(context)}');
    debugPrint('Tipo de Evento: $_tipoObjetivoSelecionado');
    debugPrint('Nível da Pessoa: $_nivelPessoa');
    debugPrint('Tempo diário de treino: $_tempoDiarioSelecionado minutos');
    debugPrint('Frequência semanal: $_frequenciaSemanalSelecionada');
    debugPrint('Alergias: $_alergiasSelecionadas');
    debugPrint('Restrições Alimentares: $_restricoesAlimentaresSelecionadas');
    debugPrint('Notificações de água: $_notificacoesAguaAtivas');
    debugPrint('Termos aceitos: $_termosAceitos');
    debugPrint('==============================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plano gerado com sucesso! Veja os logs no console.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Montador de Perfil Treino')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objetivo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment<String>(
                  value: 'Emagrecimento',
                  label: Text('Emagrecimento'),
                ),
                ButtonSegment<String>(
                  value: 'Hipertrofia',
                  label: Text('Hipertrofia'),
                ),
                ButtonSegment<String>(
                  value: 'Condicionamento',
                  label: Text('Condicionamento'),
                ),
                ButtonSegment<String>(value: 'Outro', label: Text('Outro')),
              ],
              selected: {_tipoObjetivoSelecionado},
              onSelectionChanged: (novoValor) {
                if (novoValor.isNotEmpty) {
                  final tipoSelecionado = novoValor.first;
                  setState(() {
                    _tipoObjetivoSelecionado = tipoSelecionado;
                  });
                  debugPrint(
                    '[DEBUG - SegmentedButton] Tipo de objetivo selecionado: $_tipoObjetivoSelecionado',
                  );
                }
              },
            ),
            const Divider(height: 32),
            // --- 4. ChoiceChip ---
            Text(
              'Nível da Pessoa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _niveisPessoaDisponiveis.map((nivel) {
                return ChoiceChip(
                  label: Text(nivel),
                  selected: _nivelPessoa == nivel,
                  onSelected: (selecionado) {
                    if (!selecionado) {
                      return;
                    }
                    setState(() {
                      _nivelPessoa = nivel;
                    });
                    debugPrint(
                      '[DEBUG - ChoiceChip] Nível selecionado: $nivel',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),
            // --- 5. FilterChip ---
            Text(
              'Restrições alimentares',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _restricoesAlimentaresDisponiveis.map((restricao) {
                final selecionada = _restricoesAlimentaresSelecionadas.contains(
                  restricao,
                );
                return FilterChip(
                  label: Text(restricao),
                  selected: selecionada,
                  onSelected: (bool selecionado) {
                    setState(() {
                      if (selecionado) {
                        if (!_restricoesAlimentaresSelecionadas.contains(
                          restricao,
                        )) {
                          _restricoesAlimentaresSelecionadas.add(restricao);
                        }
                      } else {
                        _restricoesAlimentaresSelecionadas.remove(restricao);
                      }
                    });
                    debugPrint(
                      '[DEBUG - FilterChip] Restrição "$restricao" ${selecionado ? "adicionada" : "removida"}. Lista atual: $_restricoesAlimentaresSelecionadas',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),
            // --- 6. InputChip ---
            Text('Alergias', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _alergiaController,
              focusNode: _alergiaFocusNode,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Adicionar alergia',
                hintText: 'Ex.: Amendoim',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'Adicionar alergia',
                  onPressed: _adicionarAlergia,
                  icon: const Icon(Icons.add),
                ),
              ),
              onSubmitted: (_) => _adicionarAlergia(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _alergiasSelecionadas.map((alergia) {
                return InputChip(
                  label: Text(alergia),
                  onDeleted: () => _removerAlergia(alergia),
                );
              }).toList(),
            ),
            const Divider(height: 32),
            // --- 7. Slider ---
            Text(
              'Tempo diário de treino',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Utilize um Slider.'),
            const SizedBox(height: 8),
            Slider(
              value: _tempoDiarioSelecionado.toDouble(),
              min: _tempoDiarioMinimo.toDouble(),
              max: _tempoDiarioMaximo.toDouble(),
              divisions:
                  (_tempoDiarioMaximo - _tempoDiarioMinimo) ~/
                  _tempoDiarioIncremento,
              label: '$_tempoDiarioSelecionado min',
              onChanged: (double valor) {
                final int valorSelecionado = valor.round();
                setState(() {
                  _tempoDiarioSelecionado =
                      ((valorSelecionado - _tempoDiarioMinimo) /
                                  _tempoDiarioIncremento)
                              .round() *
                          _tempoDiarioIncremento +
                      _tempoDiarioMinimo;
                });
                debugPrint(
                  '[DEBUG - Slider] Tempo diário selecionado: $_tempoDiarioSelecionado minutos',
                );
              },
            ),
            Text('Tempo selecionado: $_tempoDiarioSelecionado minutos'),
            const Divider(height: 32),
            // --- 8. RadioListTile ---
            Text(
              'Frequência semanal',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: _frequenciaSemanalSelecionada,
              onChanged: (String? valor) {
                setState(() {
                  _frequenciaSemanalSelecionada = valor;
                });
                debugPrint(
                  '[DEBUG - RadioListTile] Frequência semanal selecionada: $_frequenciaSemanalSelecionada',
                );
              },
              child: Column(
                children: _frequenciasSemanaisDisponiveis.map((frequencia) {
                  return RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(frequencia),
                    value: frequencia,
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 32),
            // --- 9. Switch ---
            Text(
              'Notificações de água',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF4F83CC),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF305A9B)),
              ),
              child: SwitchListTile(
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF305A9B),
                title: const Text(
                  'Receber notificações para beber água',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      _notificacoesAguaAtivas ? '[ON]' : '[OFF]',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                value: _notificacoesAguaAtivas,
                onChanged: (bool ativo) {
                  setState(() {
                    _notificacoesAguaAtivas = ativo;
                  });
                  debugPrint(
                    '[DEBUG - Switch] Notificações de água alteradas para: $ativo',
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // --- 10. Checkbox ---
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Aceito os termos e condições para geração do plano de treino.',
              ),
              value: _termosAceitos,
              onChanged: (bool? aceito) {
                setState(() {
                  _termosAceitos = aceito ?? false;
                });
                debugPrint(
                  '[DEBUG - Checkbox] Termos aceitos: $_termosAceitos',
                );
              },
            ),
            const SizedBox(height: 16),
            // --- Botões de Ação Final (Cancelar e Gerar Plano) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gerarPlano,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Gerar Plano'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: resetarValores,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFBE5B45),
                      side: const BorderSide(
                        color: Color(0xFFBE5B45),
                        width: 1.5,
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _adicionarAlergia() {
    final alergiaInformada = _alergiaController.text.trim();

    if (alergiaInformada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe uma alergia antes de adicionar.'),
        ),
      );
      return;
    }

    final alergiaNormalizada = alergiaInformada.toLowerCase();
    final jaExiste = _alergiasSelecionadas.any(
      (alergia) => alergia.toLowerCase() == alergiaNormalizada,
    );

    if (jaExiste) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Essa alergia já foi adicionada.')),
      );
      return;
    }

    setState(() {
      _alergiasSelecionadas.add(alergiaInformada);
      _alergiaController.clear();
    });

    _alergiaFocusNode.requestFocus();
    debugPrint('[DEBUG - InputChip] Alergia adicionada: $alergiaInformada');
  }

  void _removerAlergia(String alergia) {
    setState(() {
      _alergiasSelecionadas.remove(alergia);
    });
    debugPrint('[DEBUG - InputChip] Alergia removida: $alergia');
  }
}

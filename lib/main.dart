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
  static final Map<String, bool> _servicosPadrao = {
    'Buffet': false,
    'Fotografia': false,
    'Decoração': false,
    'DJ': false,
  };
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
  static const bool _notificacaoAtivaPadrao = false;

  // --- 2. Variáveis de Estado ---
  DateTime _dataSelecionada = _dataPadrao;
  TimeOfDay _horarioSelecionado = _horarioPadrao;
  String _tipoObjetivoSelecionado = _tipoPadrao;
  String _nivelPessoa = _nivelPessoaPadrao;
  Map<String, bool> _servicosSelecionados = Map.from(_servicosPadrao);
  List<String> _restricoesAlimentaresSelecionadas = List<String>.from(
    _restricoesAlimentaresPadrao,
  );
  bool _notificacaoAtiva = _notificacaoAtivaPadrao;

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
    _servicosSelecionados = Map.from(_servicosPadrao);
    _restricoesAlimentaresSelecionadas = List<String>.from(
      _restricoesAlimentaresPadrao,
    );
    _notificacaoAtiva = _notificacaoAtivaPadrao;
  }

  void resetarValores() {
    setState(_aplicarValoresPadrao);
    debugPrint('[DEBUG] Formulario resetado para os valores padrao.');
  }

  void salvarFormulario() {
    debugPrint('==============================');
    debugPrint('       RESUMO DO AGENDAMENTO   ');
    debugPrint('==============================');
    debugPrint(
      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
    );
    debugPrint('Horário: ${_horarioSelecionado.format(context)}');
    debugPrint('Tipo de Evento: $_tipoObjetivoSelecionado');
    debugPrint('Nível da Pessoa: $_nivelPessoa');
    debugPrint('Serviços selecionados: $_servicosSelecionados');
    debugPrint('Restrições Alimentares: $_restricoesAlimentaresSelecionadas');
    debugPrint('Lembrete Automático: $_notificacaoAtiva');
    debugPrint('==============================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento salvo com sucesso! Veja os logs no console.'),
      ),
    );
  }

  // --- Funções Auxiliares para Pickers ---
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (data != null && data != _dataSelecionada) {
      setState(() {
        _dataSelecionada = data;
      });
      debugPrint('[DEBUG - DatePicker] Data selecionada: $data');
    }
  }

  Future<void> _selecionarHorario(BuildContext context) async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
    );

    if (horario != null && horario != _horarioSelecionado) {
      setState(() {
        _horarioSelecionado = horario;
      });
      debugPrint(
        '[DEBUG - TimePicker] Horário selecionado: ${horario.format(context)}',
      );
    }
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
            // --- 6. Checkbox ---
            Text(
              'Serviços Adicionais',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Column(
              children: _servicosSelecionados.keys.map((servico) {
                return CheckboxListTile(
                  dense: true,
                  title: Text(servico),
                  value: _servicosSelecionados[servico],
                  onChanged: (marcado) {
                    setState(() {
                      _servicosSelecionados[servico] = marcado ?? false;
                    });
                    debugPrint(
                      '[DEBUG - Checkbox] Serviço "$servico" alterado para: $marcado',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),
            // --- 7. Switch ---
            SwitchListTile(
              title: const Text('Enviar Lembrete Automático'),
              subtitle: const Text(
                'Notificar convidados 24 horas antes do evento.',
              ),
              value: _notificacaoAtiva,
              onChanged: (bool ativo) {
                setState(() {
                  _notificacaoAtiva = ativo;
                });
                debugPrint(
                  '[DEBUG - Switch] Notificação automática alterada para: $ativo',
                );
              },
            ),
            const SizedBox(height: 24),
            // --- Botões de Ação Final (Cancelar e Salvar) ---
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
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: salvarFormulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Salvar'),
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
}

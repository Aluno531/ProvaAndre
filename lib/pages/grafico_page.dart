import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import './veiculos/veiculos_model.dart';
import './abastecimento/abastecimento_model.dart';
import '../services/veiculos_service.dart';
import './abastecimento/abastecimento_service.dart';

class GraficoPage extends StatefulWidget {
  const GraficoPage({super.key});

  @override
  State<GraficoPage> createState() => _GraficoPageState();
}

class _GraficoPageState extends State<GraficoPage> {
  final VeiculosService _veiculosService = VeiculosService();
  final AbastecimentoService _abastecimentoService = AbastecimentoService();

  List<Veiculo> _veiculos = [];
  List<Abastecimento> _abastecimentos = [];

  String? _veiculoSelecionadoId;
  bool _loadingVeiculos = true;
  bool _loadingAbastecimentos = false;

  @override
  void initState() {
    super.initState();
    _carregarVeiculos();
  }

  Future<void> _carregarVeiculos() async {
    try {
      final snapshot = await _veiculosService.veiculosRef.get();
      final veiculos = snapshot.docs
          .map((doc) => Veiculo.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _veiculos = veiculos;
        _loadingVeiculos = false;
      });
    } catch (e) {
      setState(() => _loadingVeiculos = false);
      print("Erro ao carregar veículos: $e");
    }
  }

  Future<void> _carregarAbastecimentos(String veiculoId) async {
    setState(() {
      _abastecimentos = [];
      _loadingAbastecimentos = true;
    });

    try {
      final snapshot = await _abastecimentoService.abastecimentosRef
          .where("veiculoId", isEqualTo: veiculoId)
          .orderBy("data")
          .get();

      final lista = snapshot.docs
          .map((doc) => Abastecimento.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _abastecimentos = lista;
        _loadingAbastecimentos = false;
      });
    } catch (e) {
      setState(() => _loadingAbastecimentos = false);
      print("Erro ao carregar abastecimentos: $e");
    }
  }

  List<FlSpot> _gerarPontos() {
    if (_abastecimentos.isEmpty) return [];
    return List.generate(
      _abastecimentos.length,
      (index) => FlSpot(index.toDouble(), _abastecimentos[index].quantidadeLitros),
    );
  }

  double _maxY() {
    if (_abastecimentos.isEmpty) return 10;

    final max = _abastecimentos
        .map((a) => a.quantidadeLitros)
        .reduce((a, b) => a > b ? a : b);

    
    return ((max ~/ 5) + 1) * 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gráfico de Consumo Litro/Km"),
        backgroundColor: Colors.purple,
      ),
      body: _loadingVeiculos
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _veiculoSelecionadoId,
                    decoration: const InputDecoration(
                      labelText: "Selecione o Veículo",
                      border: OutlineInputBorder(),
                    ),
                    items: _veiculos
                        .map((v) => DropdownMenuItem(
                              value: v.id,
                              child: Text("${v.marca} ${v.modelo} - ${v.placa}"),
                            ))
                        .toList(),
                    onChanged: (id) {
                      setState(() {
                        _veiculoSelecionadoId = id;
                        _abastecimentos = [];
                      });
                      if (id != null) {
                        _carregarAbastecimentos(id);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _veiculoSelecionadoId == null
                        ? const Center(
                            child: Text(
                              "Selecione um veículo para ver o gráfico.",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : _loadingAbastecimentos
                            ? const Center(child: CircularProgressIndicator())
                            : _abastecimentos.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Nenhum abastecimento encontrado.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : LineChart(
                                    LineChartData(
  minX: 0,
  maxX: (_abastecimentos.length - 1).toDouble(),
  minY: 0,
  maxY: _maxY(),
  titlesData: FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 1,
      reservedSize: 28,
      getTitlesWidget: (value, meta) {
        int index = value.round();
        if (index < 0 || index >= _abastecimentos.length) return const Text("");
        final data = _abastecimentos[index].data;
        return Text(
          "${data.day}/${data.month}",
          style: const TextStyle(fontSize: 10),
        );
      },
    ),
  ),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 5,
      getTitlesWidget: (value, meta) {
        return Text(value.toInt().toString());
      },
      reservedSize: 40,
    ),
  ),
  topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false), 
  ),
  rightTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 5,
      getTitlesWidget: (value, meta) {
        return Text(value.toInt().toString());
      },
      reservedSize: 40,
    ),
  ),
),

  gridData: FlGridData(show: true),
  borderData: FlBorderData(show: true),
  lineBarsData: [
    LineChartBarData(
      spots: _gerarPontos(),
      isCurved: true,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.purple.withOpacity(0.1),
          ],
        ),
      ),
      color: Colors.purple,
    ),
  ],
)

                                  ),
                  ),
                ],
              ),
            ),
    );
  }
}

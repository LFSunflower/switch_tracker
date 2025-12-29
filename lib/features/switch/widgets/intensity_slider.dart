import 'package:flutter/material.dart';

// Widget sem estado para controlar o slider de intensidade
class IntensitySlider extends StatelessWidget {
  // Valor atual da intensidade (1-5)
  final int value;
  // Callback para quando o valor do slider mudar
  final Function(int) onChanged;

  // Construtor com parâmetros obrigatórios
  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  // Método que retorna o texto descritivo baseado no nível de intensidade
  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Muito Leve';
      case 2:
        return 'Leve';
      case 3:
        return 'Moderado';
      case 4:
        return 'Intenso';
      case 5:
        return 'Muito Intenso';
      default:
        return '';
    }
  }

  // Método que retorna a cor baseada no nível de intensidade
  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    // Coluna que organiza o slider e o container de informações verticalmente
    return Column(
      children: [
        // Slider deslizante com valores de 1 a 5
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (newValue) => onChanged(newValue.toInt()),
        ),
        // Container que exibe o nível e label da intensidade com estilo colorido
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          // Decoração com cor de fundo, borda e cantos arredondados
          decoration: BoxDecoration(
            color: _getIntensityColor(value).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getIntensityColor(value),
              width: 2,
            ),
          ),
          // Linha que organiza o texto do nível e label horizontalmente
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Texto que exibe o número do nível atual
              Text(
                'Nível: $value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getIntensityColor(value),
                ),
              ),
              // Texto que exibe a descrição da intensidade
              Text(
                _getIntensityLabel(value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _getIntensityColor(value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
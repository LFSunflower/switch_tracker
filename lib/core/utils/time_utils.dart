class TimeUtils {
  /// Formata uma duração em um formato legível
  /// Exemplo: 1h 30m, 45m, 2h, etc
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    // Se menos de 1 minuto, mostra segundos
    if (hours == 0 && minutes == 0) {
      return '${seconds}s';
    }

    // Se menos de 1 hora, mostra apenas minutos e segundos
    if (hours == 0) {
      if (seconds == 0) {
        return '${minutes}m';
      }
      return '${minutes}m ${seconds}s';
    }

    // Se 1 hora ou mais, mostra horas e minutos
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Calcula a diferença entre duas datas em duração
  static Duration calculateDuration(DateTime startTime, DateTime? endTime) {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Formata uma data no padrão brasileiro: dd/MM/yyyy
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Formata uma hora no padrão HH:mm
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Formata data e hora completas
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Retorna uma descrição relativa do tempo (ex: "há 2 horas")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'há alguns segundos';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'há $minutes minuto${minutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'há $hours hora${hours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'há $days dia${days > 1 ? 's' : ''}';
    } else {
      return formatDate(dateTime);
    }
  }
}

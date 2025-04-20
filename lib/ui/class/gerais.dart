String formatarCodigosEAN(String texto) {
  final RegExp eanRegex = RegExp(r'^\d{8}$|^\d{13}$');

  final codigosValidos =
      texto
          .split(RegExp(r'[,\n]')) // quebra por vírgula ou nova linha
          .map((c) => c.trim()) // tira espaços
          .where((c) => eanRegex.hasMatch(c)) // mantém apenas EAN válidos
          .toSet() // remove duplicados
          .toList();

  return codigosValidos.map((c) => '$c,').join('\n');
}

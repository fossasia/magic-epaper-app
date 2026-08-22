enum ConsoleLineType { input, output, error, info, system }

class ConsoleLine {
  final String text;
  final ConsoleLineType type;

  const ConsoleLine(this.text, this.type);

  const ConsoleLine.input(this.text) : type = ConsoleLineType.input;
  const ConsoleLine.output(this.text) : type = ConsoleLineType.output;
  const ConsoleLine.error(this.text) : type = ConsoleLineType.error;
  const ConsoleLine.info(this.text) : type = ConsoleLineType.info;
  const ConsoleLine.system(this.text) : type = ConsoleLineType.system;
}

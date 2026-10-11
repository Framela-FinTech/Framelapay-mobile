/// One row in the "Processing Transfer" timeline.
/// The processing screen is generic — each flow supplies its own list,
/// so the same screen serves both the stablecoin and fiat flows.
class ProcessingStep {
  final String title;
  final String time; // empty string = no timestamp yet
  final String subtitle;
  final bool done;

  const ProcessingStep({
    required this.title,
    this.time = '',
    required this.subtitle,
    this.done = false,
  });
}

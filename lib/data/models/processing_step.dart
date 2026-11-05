/// One row in the "Processing Transfer" timeline.
/// The processing screen is generic — each flow supplies its own list,
/// so the same screen serves both the stablecoin and fiat flows.
class ProcessingStep {
  final String title;

  /// Timestamp for a finished step, or the status word Figma shows in the
  /// same slot for the others ("In progress", "Next", "Awaiting payout").
  final String time;
  final String subtitle;
  final bool done;

  /// The step currently running — rendered as an amber clock between the
  /// green ticks above it and the empty circles below.
  final bool inProgress;

  const ProcessingStep({
    required this.title,
    this.time = '',
    required this.subtitle,
    this.done = false,
    this.inProgress = false,
  });
}

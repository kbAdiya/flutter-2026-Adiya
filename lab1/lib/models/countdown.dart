sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  const Upcoming(this.remaining);

  final Duration remaining;
}

class Started extends Countdown {
  const Started(this.elapsed);

  final Duration elapsed;
}

class Ended extends Countdown {
  const Ended();
}

Countdown countdownFor(DateTime start, DateTime now) {
  if (now.isBefore(start)) {
    return Upcoming(start.difference(now));
  }

  final elapsed = now.difference(start);

  if (elapsed < const Duration(hours: 1)) {
    return Started(elapsed);
  }

  return const Ended();
}

String countdownText(Countdown countdown) {
  return switch (countdown) {
    Upcoming(:final remaining) => 'Starts in ${remaining.inMinutes} min',
    Started(:final elapsed) => 'Started ${elapsed.inMinutes} min ago',
    Ended() => 'Ended',
  };
}

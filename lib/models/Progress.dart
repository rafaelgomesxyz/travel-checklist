class Progress {
  int _current = 0;
  int _total = 0;

  Progress(int current, int total) {
    this._current = current;
    this._total = total;
  }

  set current(int current) => this._current = current;

  set total(int total) => this._total = total;

  int get current => this._current;

  int get total => this._total;

  void increaseCurrent() {
    this._current += 1;
  }

  void decreaseCurrent() {
    this._current -= 1;
  }

  void increaseTotal() {
    this._total += 1;
  }

  void decreaseTotal() {
    this._total -= 1;
  }
}
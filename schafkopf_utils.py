from functools import lru_cache


@lru_cache(maxsize=None)
def fac(n: int) -> int:
    """Berechnet die Fakultät von n.

    >>> fac(n=0)
    1
    >>> fac(n=1)
    1
    >>> fac(n=5)
    120
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    return 1 if n == 0 else n * fac(n - 1)


@lru_cache(maxsize=None)
def ncr(n: int, k: int) -> int:
    """Berechnet die Anzahl der Möglichkeiten, k Elemente aus n Elementen zu wählen.

    >>> ncr(n=3, k=2)
    3
    >>> ncr(n=4, k=2)
    6
    """
    return fac(n) // (fac(k) * fac(n - k))


@lru_cache(maxsize=None)
def genau(n_total: int, n_ich: int, n_gegner: int) -> float:
    """Berechnet die Wahrscheinlichkeit, dass ein anderer genau n_gegner spezielle Karten hat, von denen es n_total
    gibt und ich n_ich habe.

    >>> genau(n_total=4, n_ich=2, n_gegner=2)  # Geier stehen zusammen
    0.29411764705882354
    >>> genau(n_total=12, n_ich=5, n_gegner=4)  # Solo mit 5 Trumpf, Gegner hat 4 Trumpf
    0.31108597285067874
    >>> genau(n_total=5, n_ich=3, n_gegner=2)  # Wenz-Tout ich A, K, 9 einer Farbe, Gegner 2 andere
    0.29411764705882354
    """
    return ncr(3, 1) * ncr(n_total - n_ich, n_gegner) * ncr(24 - n_total - (6 - n_ich), 6 - n_gegner) / ncr(18, 6)


@lru_cache(maxsize=None)
def oder_mehr(n_total: int, n_ich: int, n_gegner_min: int) -> float:
    """Berechnet die Wahrscheinlichkeit, dass ein anderer mindestens n_gegner_min spezielle Karten hat, von denen es n_total
    gibt und ich n_ich habe.

    >>> oder_mehr(n_total=12, n_ich=5, n_gegner_min=4)  # Solo mit 5 Trumpf, Gegner hat 4 oder mehr Trumpf
    0.3495475113122172
    >>> oder_mehr(n_total=12, n_ich=6, n_gegner_min=5)  # Solo mit 6 Trumpf, Gegner hat 5 oder mehr Trumpf
    0.011797026502908856
    """
    min_gegner = n_gegner_min
    max_gegner = min(6, n_total - n_ich)
    p = 0
    for n_gegner in range(min_gegner, max_gegner + 1):
        p += genau(n_total, n_ich, n_gegner)
    return p


def erwartungswert(n_total: int, n_ich: int, n_gegner_min: int, k: int) -> float:
    """Berechnet den Erwartungswert für das Spiel - mit Kontrafaktor k (0, 1)-Dummy. Ignoriert Schneider, Schwarz etc.

    >>> erwartungswert(n_total=12, n_ich=5, n_gegner_min=4, k=0)  # Solo mit 5 Trumpf, Gegner hat 4 oder mehr Trumpf
    0.30090497737556565
    >>> erwartungswert(n_total=12, n_ich=5, n_gegner_min=4, k=1)  # same, mit kontra
    -0.04864253393665152
    >>> erwartungswert(n_total=5, n_ich=3, n_gegner_min=2, k=0)  # Wenz-Tout ich A+2 einer Farbe hat und nur das Zusammenstehen der anderen beiden ein Problem
    0.4117647058823528
    """
    p_sieg = 1 - oder_mehr(n_total, n_ich, n_gegner_min)  # Wahrscheinlichkeit für Sieg
    e = p_sieg - (1 - p_sieg) * (1 + k)  # k verdoppelt, Annahme: wird nur gegeben, wenn erfolgreich
    return e

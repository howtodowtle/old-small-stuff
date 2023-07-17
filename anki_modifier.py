#! /usr/bin/env python3

import argparse
import math


def new_modifier(current_modifier: float, current_success_rate: float, desired_success_rate: float = 0.85) -> float:
    """Returns the new interval modifier for a deck.

    new modifier = log(desired success rate) / log(current success rate) * current modifier

    How to get the input data:
    - current modifier = 'interval modifier' in deck options
    - current success rate = success rate of only the mature cards in the last three months, read from deck statistics
    - desired success rate = 85% (or whatever you want)
    """
    return math.log(desired_success_rate) / math.log(current_success_rate) * current_modifier


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Calculate the new interval modifier for a deck.")
    parser.add_argument("-m", "--current-modifier", type=float, required=True, help="The current interval modifier of the deck.")
    parser.add_argument("-s", "--current-success-rate", type=float, required=True, help="The current success rate of the deck.")
    parser.add_argument("-d", "--desired-success-rate", type=float, default=0.85, help="The desired success rate of the deck.")
    return parser.parse_args()


def main():
    args = parse_args()
    res = new_modifier(args.current_modifier, args.current_success_rate, args.desired_success_rate)
    print(f"New modifier: {res:.2f}")


if __name__ == "__main__":
    main()

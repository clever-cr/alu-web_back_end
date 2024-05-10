#!/usr/bin/env python3
"""define function make_multiplier"""

from typing import Callable


def make_multiplier(multiplier: float) -> Callable[[float], float]:
    """multiply funcion"""

    def multiply(n: float) -> float:
        """multiply"""
        return n * multiplier
    return multiply

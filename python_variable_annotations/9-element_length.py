#!/usr/bin/env python3
"""define element_length function"""
from typing import List, Tuple, Sequence, Iterable


def element_length(lst: Iterable[Sequence]) -> List[Tuple[Sequence, int]]:
    """return list with string and number"""
    return [(i, len(i)) for i in lst]

#!/usr/bin/env python3
"""define function sum_mixed_list"""

from typing import Union, List


def sum_mixed_list(mxd_lst: List[Union[int, float]]) -> float:
    """Add list items"""
    return sum(mxd_lst)

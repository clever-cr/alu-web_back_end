#!/usr/bin/env python3
"""Simple helper function"""


def index_range(page, page_size):
    """ return a tuple of size two containing a start index and an
        end index corresponding to the range
        of indexes to return in a list for those
        particular pagination parameters.
    """
    if (page == 1):
        return (0, page_size)
    start = (page - 1) * page_size
    end = start + page_size
    return (start, end)

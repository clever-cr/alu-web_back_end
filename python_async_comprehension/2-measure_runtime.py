#!/usr/bin/env python3
"""Measure the runtime"""

import asyncio
import time

async_comprehension = __import__('1-async_comprehension').async_comprehension


async def measure_runtime() -> float:
    """Measure the runtime"""
    start = time.time()
    await asyncio.gather(asyncio.create_task(async_comprehension()),
                         asyncio.create_task(async_comprehension()),
                         asyncio.create_task(async_comprehension()),
                         asyncio.create_task(async_comprehension()))
    end = time.time()
    return end - start

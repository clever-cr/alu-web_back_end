#!/usr/bin/env python3
"""get all the data from a collection"""

def list_all(mongo_collection):
    """list all documents in a collection"""
    return list(mongo_collection.find())

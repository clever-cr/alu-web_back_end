#!/usr/bin/env python3
"""update school document in a collection"""


def update_topics(mongo_collection, name, topics):
    """update school document in a collection"""
    mongo_collection.update_many({"name": name}, {"$set": {"topics": topics}})

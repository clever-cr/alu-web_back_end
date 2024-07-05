#!/usr/bin/env python3
""" log stats """
from pymongo import MongoClient

def main(collection, options=None):
    """ log stats"""
    

    num_logs = collection.count({})
    methods = ["GET", "POST", "PUT", "PATCH", "DELETE"]
    results = [0, 0, 0, 0, 0]
    num_status_check = collection.count({"method": "GET", "path": "/status"})
    for method in methods:
        num_method = collection.count({"method": method})
        results[methods.index(method)] = num_method
    
    print("{} logs".format(num_logs))
    print("Methods:")
    for method in methods:
        print("\tmethod {}: {}".format(method, results[methods.index(method)]))
    
    print("{} status check".format(num_status_check))





if __name__ == "__main__":
    client = MongoClient()
    db = client.logs
    logs = db.nginx
    main(logs)

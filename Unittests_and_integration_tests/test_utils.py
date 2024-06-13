#!/user/bin/env python3

import unittest
from parameterized import parameterized
from utils import access_nested_map
from unittest.mock import patch
import requests 
class TestAccessNestedMap(unittest.TestCase):
    """ Test for acess_nested_map"""

    @parameterized.expand([
        ({"a": 1}, ("a",), 1),
        ({"a": {"b": 2}}, ("a",), {"b": 2}),
        ({"a": {"b": 2}}, ("a", "b"), 2),
    ])
    def test_access_nested_map(self,nested_map,path,expected):
        """ Test for acess_nested_map"""
        self.assertEqual(access_nested_map(nested_map,path),expected)
    
    @parameterized.expand([
        ({}, ("a",)),
        ({"a": 1}, ("a", "b")),
    ])
    def test_access_nested_map_exception(self, nested_map,path):
        """Test for keyError exception"""
        with self.assertRaises(KeyError):
            access_nested_map(nested_map,path)
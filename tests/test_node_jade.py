import unittest
import requests
import os
import sys
import random

sys.path.insert(1, os.path.join(sys.path[0], '..'))
from plugins.engines.jade import Jade
from basetest import BaseTest


class JadeTest(unittest.TestCase, BaseTest):

    expected_data = {
        'language': 'javascript',
        'engine': 'jade',
        'eval' : 'javascript' ,
        'exec' : True,
        'read' : True,
        'write' : True,
        'trailer_fmt': '\n= %(trailer)s\n',
        'header_fmt': '\n= %(header)s\n',
        'render_fmt': '\n= %(payload)s\n',
    }

    url = 'http://127.0.0.1:15004/jade?inj=*&tpl=%s'
    plugin = Jade

    reflection_tests = [
        (1, 1, '%s', {}),
        (1, 1, 'AAA%sAAA', {}),

        (1, 1, 'a(href=\'%s\')', { 'prefix' : '1\')', 'suffix' : '//' }),
        (1, 1, 'a(href="%s")', { 'prefix' : '1")', 'suffix' : '//' }),
        (2, 1, '#container.%s', {  }),
        (2, 1, '#{%s}', { 'prefix' : '1}', 'suffix' : '//' }),

        (2, 2, '- var %s = true', { 'prefix' : 'a\n', 'suffix' : '//' }),
        (2, 1, '- var a = %s', { }),

    ]

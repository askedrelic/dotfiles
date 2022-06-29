#!/usr/bin/env python
"""
Convert JSON data to human-readable form.

(Reads from stdin and writes to stdout)
"""

import sys
#import simplejson as json
import json


print json.dumps(json.loads(sys.argv[1]), indent=4)
sys.exit(0)

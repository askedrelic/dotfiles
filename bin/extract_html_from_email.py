#! /usr/bin/env python

import email
import sys

textfile = sys.argv[1]
fp = open(textfile, 'rb')
e = email.message_from_file(fp)

# TODO: improve this to detect HTML payload
p = e.get_payload()[1]

# print email html content
print p.get_payload(decode=True)

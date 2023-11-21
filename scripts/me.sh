#!/usr/bin/env python3

'''
First, install the latest release of Python wrapper: $ pip install ovh
'''
import json
import ovh

# Instanciate an OVH Client.
# You can generate new credentials with full access to your account on
# the token creation page
client = ovh.Client(
    endpoint='ovh-eu',               # Endpoint of API OVH Europe (List of available endpoints)
    application_key='xx',    # Application Key
    application_secret='yy', # Application Secret
    consumer_key='zz',       # Consumer Key
)

result = client.get('/me')

# Pretty print
print json.dumps(result, indent=4)

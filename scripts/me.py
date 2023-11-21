#!/usr/bin/env python3


import json
import ovh
import os

client = ovh.Client(
        endpoint="ovh-eu",
        application_key=os.environ["OVH_APPLICATION_KEY"],
        application_secret=os.environ["OVH_APPLICATION_SECRET"],
        consumer_key=os.environ["OVH_CONSUMER_KEY"],
)

print(json.dumps(client.get("/me"), indent=4))

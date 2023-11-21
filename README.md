# ovhcloud-mks-benchmarks

This repository allows you to create some benchmarks for OVHcloud Managed Kubernetes Service.

Through this procedure, you can [create multiple OVHcloud Managed Kubernetes, through Terraform](https://docs.ovh.com/gb/en/kubernetes/creating-a-cluster-through-terraform/).

We will create, in parallel, several Kubernetes clusters in OVH, with a functional deployment and a service.

# Prerequisites

Generate [OVH API credentials](https://api.ovh.com/createToken/?GET=/*&POST=/*&PUT=/*&DELETE=/*) and then export in environment variables in your machine like this:

```
$ export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxxxx"
export OVH_CONSUMER_KEY="xxxxx"
```

Or you can directly put them in `provider.tf` in ovh provider definition:

```
provider "ovh" {
  version            = "~> 0.16"
  endpoint           = "ovh-eu"
  application_key    = "xxx"
  application_secret = "xxx"
  consumer_key       = "xxx"
}
```

# Configuration

In `variables.tf` file you can change several useful parameters.

First, set your `service_name` parameter (Public Cloud project ID):

```
variable "service_name" {
  default = "xxxxx"
}
```

You can also change the number of nodes (1 by default):

```
variable "nb_nodes" {
  default = 1
}
```

The region can also be changed:

```
variable "region" {
  default = "GRA7"
}
```

And the type of machines for the nodes, too:

```
variable "flavor_name" {
  default = "b2-7"
}
```

# How To

A script have been made to:
- Create the Kubernetes clusters
- and for each:
    - apply a deployment
    - a service
    - and when the load balancer is created, curl the app to know when it is ready

Launch the script to launch the bench:

```
./scripts/script.sh
```

Output are writted in `logs` file.

```
tail -f logs
```

When the script hve finished to run, you should have a little report:

```
Report:
START: Mar 21 nov 2023 11:03:30 CET
MIDDLE: Mar 21 nov 2023 11:15:50 CET (0:12:20)
END: Mar 21 nov 2023 11:17:32 CET (0:14:02)

Details:
- cluster creation:
- nodepool creation:

Total:
- Cluster & node pool creation: 0:12:20
- Total (after app deployment): 0:14:02
```

To have a complete report, the only thing to do is to copy/paste the creation time for the cluster and the node pool ;-).

# Clean

You can remove generated files and OVHcloud resources created:

```
./scripts/clean.sh
```

# Test if your credentials are still valid:

```
$ cd scripts/
$ pip3 install ovh 
$ python3 me.py
{
    "birthCity": "",
    "email": "xxx@xxx.com",
    "city": "xxx",
    "companyNationalIdentificationNumber": null,
    "currency": {
        "symbol": "\u20ac",
        "code": "EUR"
    },
    "sex": null,
    "fax": "",
    "area": "",
    "italianSDI": "xxxxxxxx",
    "name": "xx",
    "zip": "xxxxx",
    "organisation": "",
    "corporationType": "",
    "firstname": "xxx",
    "legalform": "individual",
    "nichandle": "xx",
    "vat": "",
    "spareEmail": null,
    "language": "fr_FR",
    "customerCode": "xxxx-xxxx-xx",
    "birthDay": "",
    "state": "complete",
    "address": "xxxxxx",
    "ovhSubsidiary": "FR",
    "phone": "+33.xxxxxxxxx",
    "nationalIdentificationNumber": null,
    "phoneCountry": "FR",
    "country": "FR"
}
```

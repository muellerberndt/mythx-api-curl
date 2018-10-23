<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Introduction](#introduction)
- [Setup](#setup)
- [Using](#using)
    - [To submit a job for use `analyses.sh` for analysis:](#to-submit-a-job-for-use-analysessh-for-analysis)
    - [To job status of a job run (UUID)](#to-job-status-of-a-job-run-uuid)
    - [To see the results of status:](#to-see-the-results-of-status)
    - [Get the API version number](#get-the-api-version-number)
    - [Get the OpenAPI specification](#get-the-openapi-specification)

<!-- markdown-toc end -->

# Introduction

Here are some shell scripts, that you can use to work with the [Mythril Platform](https://mythril.ai/) (in private alpha right now).

# Setup

To run these you need:

* [bash](https://www.gnu.org/software/bash/),
* [curl](https://curl.haxx.se/download.html) to make the HTTPS requests, and
* [jq](https://stedolan.github.io/jq/download/) to make the JSON output prettier

Most OS's have these available. Run `./prerequisites.sh` to double check though.

After ensuring you have the prerquistes programs, set `MYTHRIL_API` to
your API key. For example:

```console
$ export MYTHRIL_API_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
$ export MYTHRIL_API_URL='http://api.mythril.ai'
$ export EMAIL=you@example.com
```

Above `MYTHRIL_API_URL` is optional and the default value is given above.
We have however a number of API servers. If you are using one or using
your own private version, set the URL host accordiatingly.

# Using

Once you are set up, you can:

* Submit a contract for analysis, creating a job run with a UUID
* See the status of job using the UUID of a previously submitted analysis
* Get the results of a previously finished analysis using the UUID
* See a list of previously submitted analyses
* Get the current versions of Mythril API and its core sub-modules
* Get the OpenAPI specification

To submit a job for use `analyses.sh` for analysis:
---------------------------------------------------------------

```console
$ ./analyses.sh sample-json/PublicArray.js
Issuing HTTP POST http://api.mythril.ai/v1/analyses
  (with MYTHRIL_API_KEY and EVM bytecode)
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "result": "Queued",
  "uuid": "bf9fe267-d322-4641-aae2-a89e62f40770"
}
```

## To job status of a job run (UUID)


```console
$ ./analyses-status.sh "bf9fe267-d322-4641-aae2-a89e62f40770"
Issuing HTTP GET http://api.mythril.ai/v1/analyses/bf9fe267-d322-4641-aae2-a89e62f40770
  (with MYTHRIL_API_KEY)
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "result": "Finished",
  "uuid": "bf9fe267-d322-4641-aae2-a89e62f40770"
}
```

## To see the results of status:

```console
$ ./analyses-results.sh "bf9fe267-d322-4641-aae2-a89e62f40770"
Issuing HTTP GET http://api.mythril.ai/v1/analyses/bf9fe267-d322-4641-aae2-a89e62f40770/issues
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
[
  {
    "address": 499,
    "contract": "MAIN",
    "debug": "callvalue: 0xd7ee0142c5f24581862400cc4785a2910417ad282802609755ac30ac4c9e435d\nstorage_keccac_1461501637330902918203684832716283019655932542975_&\n1461501637330902918203684832716283019655932542975_&\n1461501637330902918203684832716283019655932542975_&\ncalldata_MAIN[4]: 0x744240060f11ee8302555055dccca6b72611ae29090e239231b0a7b8f29ae057\ncalldata_MAIN[0]: 0x362a9500000000000000000000000000000000000000000000000000000000\ncalldatasize_MAIN: 0x4\n",
    "description": "A possible integer overflow exists in the function `fallback`.\nThe addition or multiplication may result in a value higher than the maximum representable integer.",
    "function": "fallback",
    "title": "Integer Overflow",
    "type": "Warning"
  },
  {
    "address": 648,
    "contract": "MAIN",
    "debug": "",
    "description": "This contract executes a message call to the address of the transaction sender. Generally, it is not recommended to call user-supplied addresses using Solidity's call() construct. Note that attackers might leverage reentrancy attacks to exploit race conditions or manipulate this contract's state.",
    "function": "_function_0x2e1a7d4d",
    "title": "Message call to external contract",
    "type": "Warning"
  },
  ...
]
```

## Get the API version number

```console
$ ./api-version.sh
Issuing HTTP GET https://api.mythril.ai/v1/version
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
v1.0.20
```

## Get the OpenAPI specification

```console
$ ./get-openapi-spec.sh
Issuing HTTP GET https://api.mythril.ai/v1/openapi.yaml
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
-----------------------------------
openapi: 3.0.1
servers:
  - url: 'https://api.mythril.ai/v1'
...
```

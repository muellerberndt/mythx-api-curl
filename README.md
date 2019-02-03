<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Examples](#examples)
    - [To submit a job for use `analyses.sh` for analysis:](#to-submit-a-job-for-use-analysessh-for-analysis)
    - [To job status of a job run (UUID)](#to-job-status-of-a-job-run-uuid)
    - [To see the results of status:](#to-see-the-results-of-status)
    - [Get the API version number](#get-the-api-version-number)
    - [Get Tool Statistics](#get-tool-statistics)
    - [Get the OpenAPI specification](#get-the-openapi-specification)
- [See also](#see-also)

<!-- markdown-toc end -->

# Introduction

These shell scripts demonstrate how to use to the [MythX
API](https://staging.api.mythx.io/v1/openapi/) at the most basic level using
[curl](https://curl.haxx.se/download.html).  In using these scripts
you will see the HTTP requests that get sent along with JSON output
returned as a result of each request.

This may be useful for developers writing a programming language
interfaces to MythX, or are writing a MythX service and want the most
fine-grained control over what the API has to offer. It may be useful
also in experimenting with MythX at the API level. Note however that
some programming languages like JavaScript there is already a library
that can simplify interaction with MythX.

# Requirements

To run the MythX API shell scripts you need a couple of command-line utilities:

* [bash](https://www.gnu.org/software/bash/),
* [curl](https://curl.haxx.se/download.html) to make the HTTPS requests, and
* [jq](https://stedolan.github.io/jq/download/) to make the JSON output prettier

Those tools are already installed on most operation systems. Run `./prerequisites.sh` to double check though.

After installing the required dependencies, set
`MYTHX_PASSWORD` to and `MYTHX_ETH_ADDRESS` to the
values that have been registered. For example:

```console
$ export MYTHX_API_URL=https://mythx.io
$ export MYTHX_PASSWORD=MyPassword!
$ export MYTHX_ETH_ADDRESS=0x.............
```

Note that `MYTHX_API_URL` is optional and will be set to the default
value unless specified otherwise.

After  setting the above environment variables, you need to retrieve
a JWT access token and store it in the `MYTHX_ACCESS_TOKEN` environment variable.
To do that run:

```
$ . ./login.sh
Successfully logged into MythX
```

The scripts below will use the environment variable `MYTHX_ACCESS_TOKEN`. At some point this
access token will time out, and running commands will return a HTTP 401 error.

When that happens, then just run `. ./login.sh` again.

# Examples

Once you are set up, you can:

* Submit a contract for analysis, creating a job run with a UUID
* See the status of job using the UUID of a previously submitted analysis
* Get the results of a previously finished analysis using the UUID
* See a list of previously submitted analyses
* Get the current versions of Mythril API and its core sub-modules
* Get tool usage statistics
* Get the OpenAPI specification

## To submit a job for use `analyses.sh` for analysis:

```console
$ ./analyses.sh sample-json/PublicArray.js
Issuing HTTP POST http://api.mythx.io/v1/analyses
  (with MYTHRIL_ACCESS_TOKEN and EVM bytecode)
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
Issuing HTTP GET http://api.mythx.io/v1/analyses/bf9fe267-d322-4641-aae2-a89e62f40770
  (with MYTHRIL_ACCESS_TOKEN)
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
Issuing HTTP GET http://api.mythx.io/v1/analyses/bf9fe267-d322-4641-aae2-a89e62f40770/issues
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
Issuing HTTP GET https://api.mythx.io/v1/version
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "api": "v1.3.2",
  "maru": "0.3.4",
  "mythril": "0.20.0"
}
```

## Get Tool Statistics

```console
$ ./tool-stats.sh
Issuing HTTP GET https://api.mythx.io/v1/client-tool-stats/truffle
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "numAnalyses": 20321
}
```


## Get the OpenAPI specification

```console
$ ./get-openapi-spec.sh
Issuing HTTP GET https://api.mythx.io/v1/openapi.yaml
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
-----------------------------------
openapi: 3.0.1
servers:
  - url: 'https://api.mythx.io/v1'
...
```

# See also

* [MythX API spec](https://staging.api.mythx.io/v1/openapi/)
* [armlet](https://npmjs.org/armlet) A Javascript Wrapper around MythX
* [https://docs.mythx.io](MythX Developer and User Guide)

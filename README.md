Introduction
---------------

Here are some shell scripts, that you can use to work with the [Mythril Platform API](https://mythril.ai/) (in private alpha right now).

First set `MYTHRIL_API` to your API key. For example:

```console
$ export MYTHRIL_API_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Once that's done you can:

* Submit a contract for analysis, creating a job run with a UUID
* See the status of job using the UUID of a previously submitted analysis
* Get the results of a previously finished analysis using the UUID
* See a list of previously submitted analyses
* Get the current versions of Mythril API and its core sub-modules
* Get the OpenAPI specification

To submit a job for use `analyses.sh` for analysis:
---------------------------------------------------------------

```console
$ ./analyses.sh 60606040526004361061006c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168062362a951461006e57806327e235e31461009c5780632e1a7d4d146100e957806370a082311461010c5780638529587714610159575b005b61009a600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506101ae565b005b34156100a757600080fd5b6100d3600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506101fd565b6040518082815260200191505060405180910390f35b34156100f457600080fd5b61010a6004808035906020019091905050610215565b005b341561011757600080fd5b610143600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190505061033e565b6040518082815260200191505060405180910390f35b341561016457600080fd5b61016c610386565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b346000808373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555050565b60006020528060005260406000206000915090505481565b806000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020541015156102da573373ffffffffffffffffffffffffffffffffffffffff168160405160006040518083038185876187965a03f19250505050806000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825403925050819055505b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166001604051808260ff16815260200191505060006040518083038160008661646e5a03f19150505050565b60008060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16815600a165627a7a7230582064223a1082bfbb3bb4a508b17a422e90fced0582c3905e1bfbf384e91f6ac7d40029
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "result": "Queued",
  "uuid": "bf9fe267-d322-4641-aae2-a89e62f40770"
}
```
or
```
	$ ./analyses.sh $(cat /tmp/bytecode-file.evm)
```

To job status of a job run (UUID)
------------------------------------------

```console
$ ./analyses-status.sh "bf9fe267-d322-4641-aae2-a89e62f40770"
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
{
  "result": "Finished",
  "uuid": "bf9fe267-d322-4641-aae2-a89e62f40770"
}
```

To see the results of status:
------------------------------------

```console
$ ./analyses-results.sh "bf9fe267-d322-4641-aae2-a89e62f40770"
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

Get the API version number
---------------------------------

```console
$ ./api-version.sh
Issuing HTTP GET https://api.mythril.ai/v1/version
curl completed sucessfully. Output follows...
HTTP/1.1 200 OK
v1.0.20
```

Get the OpenAPI specification
-------------------------------------

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

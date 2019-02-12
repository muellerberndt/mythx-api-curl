#!/usr/bin/env nodejs
const request = require('request');

const basePath = 'v1/auth/login';

function usage() {
    console.log(`usage: ${process.argv[1]} [*mythril-api-json-path*] [*timeout-secs*]

Get a login session

Set environment MYTHX_PASSWORD and MYTHX_ETH_ADDRESS before using.
When successful it will print out values for
MYTHX_ACCESS_TOKEN and MYTHX_REFRESH_TOKEN suitable for
environment sourcing.
`)
    process.exit(1);
}

function fatal(mess, rc) {
    console.log(JSON.stringify(mess, null, 4));
    process.exit(rc);
}

const argLen = process.argv.length
if (argLen === 3 &&
    process.argv[2].match(/^[-]{0,2}h(?:elp)?$/)) {
    usage();
}

const apiUrl = process.env['MYTHX_API_URL'] || 'https://api.mythx.io';

if (!process.env.MYTHX_ETH_ADDRESS) {
    console.log('Please set either environment variable MYTHX_ETH_ADDRESS')
    process.exit(2);
}
if (!process.env.MYTHX_PASSWORD) {
    console.log('Please set environment variable MYTHX_PASSWORD');
    process.exit(3);
}

const password = process.env.MYTHX_PASSWORD;
const ethAddress = process.env.MYTHX_ETH_ADDRESS;

const options = {
    form: {
	ethAddress: ethAddress,
	password: password
    }};

const url = `${apiUrl}/${basePath}`

request.post(url, options, (error, res, body) => {
    if (error) {
        fatal(error, 4);
    }

    if (res.statusCode !== 200) {
	debugger
	try {
            body = JSON.parse(body)
	} catch (err) {
	}
        fatal(body, 5);
    }

    try {
        body = JSON.parse(body)
    } catch (err) {
        fatal(`echo JSON parse error ${err}`, 6);
    };

    if (!body.refresh) {
        fatal(`echo Refresh Token missing`, 7);
    }

    if (!body.access) {
        fatal(`echo Access Token missing`, 8);
    };

    console.log(`export MYTHX_ACCESS_TOKEN=${body.access}`);
    console.log(`export MYTHX_REFRESH_TOKEN=${body.refresh}`);
});

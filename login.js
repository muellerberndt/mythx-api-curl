#!/usr/bin/env nodejs
const request = require('request');

const basePath = 'v1/auth/login';

function usage() {
    console.log(`usage: ${process.argv[1]} [*mythril-api-json-path*] [*timeout-secs*]

Get a login session

Set environment MYTHRIL_PASSWORD and MYTHRIL_ETH_ADDRESS before using.
When successful it will print out values for
MYTHRIL_ACCESS_TOKEN and MYTHRIL_REFRESH_TOKEN suitable for
environment sourcing.
`)
    process.exit(1);
}

const argLen = process.argv.length
if (argLen === 3 &&
    process.argv[2].match(/^[-]{0,2}h(?:elp)?$/)) {
    usage();
}

const apiUrl = process.env['MYTHRIL_API_URL'] || 'https://api.mythril.ai';

if (!process.env.MYTHRIL_ETH_ADDRESS && !process.env.EMAIL) {
    console.log('Please set either environment variable MYTHRIL_ETH_ADDRESS ' +
		'or EMAIL')
    process.exit(2);
}
if (!process.env.MYTHRIL_PASSWORD) {
    console.log('Please set environment variable MYTHRIL_PASSWORD');
    process.exit(3);
}

const password = process.env.MYTHRIL_PASSWORD;
const ethAddress = process.env.MYTHRIL_ETH_ADDRESS;

const options = {
    form: {
	email: null,
	ethAddress: ethAddress,
	password: password
    }};

const url = `${apiUrl}/${basePath}`
debugger

request.post(url, options, (error, res, body) => {
    if (error) {
        console.log(error);
	process.exit(4);
    }

    if (res.statusCode !== 200) {
        console.log(`Invalid status code ${res.statusCode}, ${body}`);
	process.exit(5);
    }

    try {
        body = JSON.parse(body)
    } catch (err) {
        console.log(`JSON parse error ${err}`);
	process.exit(6);
    };

    if (!body.refresh) {
        console.log(`Refresh Token missing`);
	process.exit(7);
    }

    if (!body.access) {
        console.log(`Access Token missing`);
	process.exit(8);
    };

    console.log(`export MYTHRIL_ACCESS_TOKEN=${body.access}`);
    console.log(`export MYTHRIL_REFRESH_TOKEN=${body.refresh}`);
});

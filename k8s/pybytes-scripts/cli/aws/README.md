# Pybytes AWS CLI

> This package helps to deploy a source code to elasticbeanstalk instances.

### Table of Contents

- [Description](#description)
- [How To Use](#how-to-use)
- [References](#references)
- [License](#license)
- [Authors Information](#authors-information)

---

## Description

Pybytes Aws cli, helps developers (devops) to deploy application resources to elasticbeanstalk instances.

### Technologies

- NodeJs

---

## How To Use

### Installation

1. Change directory to be under `pybytes-scripts/cli/aws`
2. install required dependencies
```shell
npm install
```
OR
```shell
yarn install
```
3. install the application
```bash
npm install -g
```
OR
```shell
yarn link
```

### Uninstall

To remove the application:
1. Change directory to be under `pybytes-scripts/cli/aws`
2. unlink/uninstall the application
```shell
npm uninstall -g
```
Or
```shell
yarn unlink
```

### CLI Reference

Deploy **pybytes-logger** application for **staging** environnement for **pybytes** tenant, on **eu-west-3** region for server and **eu-west-3** region for s3 configurations

```shell
pybytes-aws deploy  --aws-environment pybytes-staging-logger \
                    --aws-application pybytes-staging  \
                    --aws-region eu-west-3 \
                    --s3-region eu-west-3 \
                    --domain-names logger.staging.pybytes.pycom.io \
                    --env staging \
                    --tenant pybytes \
                    --app-name pybytes-logger \
                    --cloud-repository git@github.com:pycom/pybytes-logger.git
                    --skip-confirm
```

Example for deploying with extra commands:

```shell
pybytes-aws deploy  --aws-environment pybytes-staging-pybytes-api \
                    --aws-application pybytes-staging \
                    --aws-region eu-west-3 \
                    --s3-region eu-west-3 \
                    --domain-names pybytes-api.staging.pybytes.pycom.io \
                    --env staging \
                    --tenant pybytes \
                    --app-name pybytes-api \
                    --cloud-repository git@github.com:pycom/pybytes-api.git \
                    --extra-commands '[ "git clone git@github.com:pycom/pybytes-api-utils.git ./packages/api-utils" ,"git clone git@github.com:pycom/pybytes-api-models.git ./packages/api-models"]'
                    --clean-temp-directory --skip-confirm
```
---
## Contributors

- Ahmad El Masri <ahmad@pycom.io>

---

## License & copyright

© 2022 Pybytes Team, Pycom Limited

This software is licensed under the GNU GPL version 3 or any later version, with permitted additional terms.

For more information see the Pycom License v1.0 document supplied with this file, or
available at https://www.pycom.io/opensource/licensing

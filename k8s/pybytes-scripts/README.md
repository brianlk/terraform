# CTRL Scripts

> Utility scripts for CTRL microservices, cli for creating release, deploy services

## Introduction

The main purpose of this repository is to provide scripts that help engineers/developers to:

* Start working on *ctrl* project
* Creating new releases
* deploy project to the target server

To be able to benefit from the scripts you should make sure that target scripts are added to your path.

The provided scripts will be compatible with **Linux/Unix** system base and we don't guaranty to provide all script to be compatible with other Operating system.

### Add scripts to your path

> Make sure to `export` the required path under `.bashrc` or `.zshrc`.

```bash
export PATH=/PATH/TO/YOUR/CTRL_SCRIPTS/Folder/pybytes-scripts/cli/ctrl:$PATH
export PATH=/PATH/TO/YOUR/CTRL_SCRIPTS/Folder/pybytes-scripts/cli/release:$PATH
```

In case you are using **Mac** do install [**ttab**](https://github.com/mklement0/ttab)
In case you are using **Debian** based system like **Ubuntu** do export the `ttab`` script to your path

```bash
export PATH=/PATH/TO/YOUR/CTRL_SCRIPTS/Folder/pybytes-scripts/cli/tools:$PATH
```
## Initialize CTRL microservices

To start working on **ctrl** you should have all related microservices/projects, the `ctrl-initialize` script help you to clone all required projects from **Pycom** GitHub repositories.

for usage please check:
```bash
ctrl-initialize --help
```

## Helpers

**Ubuntu Users:** It is recommended to close opened tabs directly and not the all terminal to ensure the ending of the process.
otherwise, you may face an issue when running the app again `(Port in use)`. However, if you got this issue, you can solve that using the below:

```
echo $(lsof -t -i:3000) && kill $(lsof -t -i:3000);
echo $(lsof -t -i:3001) && kill $(lsof -t -i:3001);
echo $(lsof -t -i:3003) && kill $(lsof -t -i:3003);
echo $(lsof -t -i:3010) && kill $(lsof -t -i:3010);
echo $(lsof -t -i:3200) && kill $(lsof -t -i:3200);
echo $(lsof -t -i:5000) && kill $(lsof -t -i:5000);
```

**Mac Users:** Fix brew issue

```bash
sudo chown -R $(whoami) $(brew --prefix)/*
```

## References:
1. [how-to-change-the-output-color-of-echo-in-linux](https://stackoverflow.com/questions/5947742)
2. [Fix homebrew permissions](https://stackoverflow.com/questions/16432071/how-to-fix-homebrew-permissions)


# IMPORTANT !!
This repository has been refactored, and a lot of old code/scripts has been removed.
Please refer [to this PR - https://github.com/pycom/pybytes-scripts/pull/183](https://github.com/pycom/pybytes-scripts/pull/183) to get/check old code

# x86-test

## Description
* This example shows how you can write `run-test.sh` and `docker-compose.yml` file \
when you want to control all actions for building your codes. 

## Conditions
* A container runtime will be executed as a user **run-test**
  * Described on `docker-compose.yml`
  * A user who runs a process in your container will be determined by `docker-compose.yml`
* `/tools/set-run-test-env.sh` has to be inserted in a local's `run-test.sh` file \
if you clone codes from Gerrit or other private git server.
* When you define **CHIP, BRANCH, BUILD_NUMBER** environment variables on `docker-compose.yml` , a container runtime creates `/work/build-lgtv` build directory and run mcf command.\
  You can see that example on **[x86-test-2nd](http://mod.lge.com/hub/tv_scm_tool/unittest-containers/tree/master/x86-test-2nd)** directory.
  ```yml
    environment:
      - CHIP=o20
      - BRANCH=@webos4tv
      - BUILD_NUMBER=226
  ```

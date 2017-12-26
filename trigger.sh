#!/bin/bash
set -e 

function print_usage(){
  echo "Usage: $0 [options] <action> <application> <inventory> <version>
        
    -v, --version    Print the version and exit.
    -h, --help       Print the help.

Available actions:
    deploy

Available applications:
    gitlab
    "
}

function print_version(){
  echo "ansible-deployer 0.0.1(dummy)"
}

if [ $# == 0 ] ; then print_usage ; exit 1 ; fi 

TEMP=`getopt -o vh --long version,help -n "error: " -- "$@"`
eval set -- "$TEMP"
while true; do
    case $1 in
        -v|--version)
            print_version ; shift ;;
        -h|--help)
            print_usage ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

readonly action=$1
readonly application=$2
readonly inventory=$3
readonly version=$4

echo "action: $action"
echo "application: $application"
echo "inventory: $inventory"
echo "version: $version"

# ansible-galaxy install -f -r requirements.yml -p roles

ansible-playbook -e host_key_checking=False -e application=$application -e version=$version -i $inventory $action.yml

# clean up
rm -rf $action.retry

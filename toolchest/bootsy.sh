#!/bin/bash

# Bootstrap basic box with configuration and provisioning tools

# I'm not a big fan of the "let's curl things and run them" 
# pattern. But life is a series of continuous improvements.

# No stdin here. Don't even ask. 
export DEBIAN_FRONTEND=noninteractive

# Use real ansible or ppa ansible? 
# Use ppa ansible for now
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get upgrade

function agi { 
    sudo apt-get install -y ${1}
}

function hashiget() { 
    _scriptfile=${1}
    _product=${2}
    _vers=${3}
    sudo ${_scriptfile} -n ${_product} -a linux_amd64 -v ${_vers} -b profile 
}

agi unzip
agi golang
agi git
agi ansible # FIXME: pin to version
agi virtualbox
agi vagrant

# get hashicorp tools
# TODO: move to a more structured mechanism

GIST_URL="https://gist.githubusercontent.com/galeep/4e00cb262d73674e787444bd63714080/raw/488fb75c16e4500ba10218291226cdc376511261/install_hashicorp_app.sh"

scriptlet="pootie"
scriptname="${scriptlet}-`date "+%s"`"

# chop it up to simplify things 
scriptbase=`basename ${scriptname}`
scriptdir=`dirname ${scriptname}`
scriptfile="${scriptdir}/${scriptbase}"

curl -s -o ${scriptfile} $GIST_URL
chmod 755 ${scriptfile}

hashiget ${scriptfile} packer 1.1.1
hashiget ${scriptfile} terraform 0.10.8

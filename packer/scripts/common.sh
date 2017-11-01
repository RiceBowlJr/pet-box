#!/bin/bash

#--[ Usual tools ]--------------------------------------------------------------
apt-get install -y \
  htop \
  mc \
  ncdu \
  tree \
  vim \
  zsh

#--[ AWS CLI ]------------------------------------------------------------------
apt-get install -y \
  python \
  python-pip
pip install --upgrade awscli


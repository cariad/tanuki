#!/usr/bin/env bash

set -e

echo -e "${li:?}Importing AWS CLI key..."
gpg --import data/aws-cli.pub

echo -e "${li:?}Downloading AWS CLI..."
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip     -o /tmp/aws.zip
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig -o /tmp/aws.zip.sig

echo -e "${li:?}Verifying AWS CLI..."
gpg --verify /tmp/aws.zip.sig /tmp/aws.zip
rm -rf /tmp/aws.zip.sig

echo -e "${li:?}Installing AWS CLI..."
unzip -q /tmp/aws.zip -d /tmp
rm -rf /tmp/aws.zip
sudo /tmp/aws/install --update
rm -rf /tmp/aws

echo -e "${ok:?}Installed AWS CLI!"
set +e

# Architecture

This codebase sets up the architecture as seen in the picture below using terraform and ansible.
![project structure](/home/david/Desktop/project.png)
To set up this architecture on your own private space; coupled with this code base, you need to include a terraform file containing access to your aws account, change the values in terraform/variable.tf to suit your peculiar needs.

## Unresolved Bug

Generating an aws key pair resulted into a libcrypto error which I didn't have the time or patience to digged into. The code piece for this action is commented out in terraform/elastic_compute.tf. I resulted to using a key pair existing on my aws account prior to this project.

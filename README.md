# Inception Of Things (IOT)

The goal of the project is to use various deployment tools:
- Vagrant
- Kubernetes
    - K3s
    - K3d
- ArgoCD

# Requirements

On your machine your are required to install vagrant
For this you can follow the steps [here](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)

# Project architecture

There are 3 folders (p1, p2, p3) representing the 3 parts of the exercise.
They are all independant and can be copied without the rest.

## Part one

The goal of this part is to create base for a DevOp project, using
Vagrant and Kubernetes in our case K3s. A good way to describe would be
a startup template.

Upon running `vagrant up` in `p1`, two VMs are created:
- A supervisor VM (suffixed S) running K3s in controller mode
- A worker VM (suffixed SW) running K3s in agent mode

This setup will be used in part two to deploy an example application.

## Part two

There we build up on the infratructure built in part one to deploy 
Paul Bouwer's [hello-kubernetes](https://hub.docker.com/r/paulbouwer/hello-kubernetes) demo app to demonstrate that kubernetes
is correctly orchestrating.

For this the app will be deployed behind 3 different domain names:
- app1.com
- app2.com
- app3.com

We do not own these domain names however to mimic the effect localy
redirecting those 3 it is possible in unix systems to create entries in
`/etc/hosts`.

Kubernetes will the be able to redirect the request to the correct pod
depending on the host the request made to.

App 2 has the added particularity to have 3 replicas, which in real conditions
is used to ensure a given service is available in case an instance of the
application goes down.

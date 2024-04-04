#!/bin/bash

# Arrêter toutes les machines virtuelles
rm -rf  .vagrant 
rm -rf *.log
VM_LIST=$(VBoxManage list runningvms | awk -F '"' '{print $2}')
for VM in $VM_LIST
do
    VBoxManage controlvm $VM acpipowerbutton
done

# Attendre quelques secondes pour que les machines s'arrêtent
sleep 3
# Supprimer toutes les machines virtuelles
VM_LIST=$(VBoxManage list vms | awk -F '"' '{print $2}')
for VM in $VM_LIST
do
    VBoxManage unregistervm $VM --delete
done

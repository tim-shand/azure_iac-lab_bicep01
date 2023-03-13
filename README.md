# AzureTrainingLab01
Azure Bicep files for deploying a test/dev environment used for training purposes. 

# Structure
### vNets ###
tjs-dev-aztraining-lab1-vnet01
	tjs-dev-aztraining-lab1-vnet1-snet1
		10.0.0.0/24
		tjs-dev-aztraining-lab01-vnet1-snet1-nsg
	tjs-dev-aztraining-lab1-vnet1-snet2
		10.1.0.0/24
		tjs-dev-aztraining-lab1-vnet1-snet2-nsg

### VMs ###
UN: linuxadmin
tjs-dev-aztraining-lab1-vm1
	tjs-dev-aztraining-lab1-vm1-pip
	tjs-dev-aztraining-lab1-vm1-disk1
	tjs-dev-aztraining-lab1-vm1-nic
	
tjs-dev-aztraining-lab1-vm2
	tjs-dev-aztraining-lab1-vm2-pip
	tjs-dev-aztraining-lab1-vm2-disk1
	tjs-dev-aztraining-lab1-vm2-nic
			
### Storage Account ##
tjsdevtaztraininglab1st


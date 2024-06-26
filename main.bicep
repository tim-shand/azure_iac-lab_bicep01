// =========== main.bicep ===========
targetScope = 'subscription'

// ***** Literals ***** //
// Resource type prefixes
//var storageAccountPrefix = 'st'

// ***** Parameters ***** //
param projectName string = '[Project_Name]'
param storageName string = '[Storage_Name]'
param location string = [Location]'
param tags object = {
  owner: '[Your_Name]'
  project: 'AzureTraining'
}

// ***** Resources ***** //
// Create: Resource Group 
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${projectName}-rg'
  location: location
}

// Create: Storage Account (boot diagnostics etc).
module newStorage 'storage.bicep' ={
  scope: newRG
  name: 'Deploy_${projectName}-st'
  params: {
    storageName: storageName
    location: location
    tags: tags
  }
}

// Create: vNet + subnets
module newVnet 'vnet.bicep' = {
  scope: newRG
  name: 'Deploy_${projectName}-vnet1'
  params: {
    vnetName: '${projectName}-vnet1'
    location: location
    tags: tags
  }
}

// Create: VMs
module newVM1 'vms.bicep' = {
  scope: newRG
  name: 'Deploy_${projectName}-vm1'
  params: {
    vmName: '${projectName}-vm1'
    adminUsername: 'linuxadmin'
    adminPasswordOrKey: '[Password]'
    location: location
    tags: tags
    storageUri: newStorage.outputs.storageUri
    subnetId: newVnet.outputs.subnetId1
  }
}
module newVM2 'vms.bicep' = {
  scope: newRG
  name: 'Deploy_${projectName}-vm2'
  params: {
    vmName: '${projectName}-vm2'
    adminUsername: 'linuxadmin'
    adminPasswordOrKey: '[Password]'
    location: location
    tags: tags
    storageUri: newStorage.outputs.storageUri
    subnetId: newVnet.outputs.subnetId2
  }
}

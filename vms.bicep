// =========== vms.bicep ===========
// # Params
param vmName string = 'vm1'
param location string = resourceGroup().location
param vmSize string = 'Standard_B2s'
param ubuntuOsVersion string = '22_04-lts-gen2'
param osDiskType string = 'Standard_LRS'
param storageUri string

param tags object = {
  tagName1: 'tag1'
  tagName2: 'tag2'
}
param subnetId string
//param privateIPAddress string = '10.0.0.5'
param adminUsername string = 'linuxadmin'
@secure()
param adminPasswordOrKey string

// Make: Public IP
resource pip1 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: '${vmName}-pip'
  location: location
  tags: tags
  properties: {
    publicIPAllocationMethod: 'Static'
    deleteOption: 'Delete'
  }
  sku: {
    name: 'Standard'
  }
}

// Make: NIC
resource nic1 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: '${vmName}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }          
          privateIPAllocationMethod: 'Dynamic'          
          primary: true
          privateIPAddressVersion: 'IPv4'
          publicIPAddress: {
            id: pip1.id
          }
        }
      }
    ]
    nicType: 'Standard'
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}
output nicId string = nic1.id

// # Make: VM
resource vm1 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        name: '${vmName}-disk1'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: 'Delete'
      }
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: ubuntuOsVersion
        version: 'latest'
      }    
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: {
        patchSettings: {
            patchMode: 'ImageDefault'
        }
      }
    }    
    networkProfile: {
      networkInterfaces: [
        {
          id: nic1.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    } 
    diagnosticsProfile: {
      bootDiagnostics: {
          enabled: true
          storageUri: storageUri
      } 
    }   
  }
}

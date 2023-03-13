// =========== vnet.bicep ===========
// # Params
param vnetName string = 'vnet1'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnet1Prefix string = '10.0.0.0/24'
param subnet1Name string = '${vnetName}-snet1'
param subnet2Prefix string = '10.0.1.0/24'
param subnet2Name string = '${vnetName}-snet2'
param location string = resourceGroup().location
param tags object = {
  tagName1: 'tag1'
  tagName2: 'tag2'
}

// # Variables
var nsgName1 = '${subnet1Name}-nsg'
var nsgName2 = '${subnet2Name}-nsg'

// # Make
resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {    
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
          networkSecurityGroup: {
            id: nsg1.id
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
          networkSecurityGroup: {
            id: nsg2.id
          }
        }
      }
    ]
  }
}

// Create subnet NSG rules.
resource nsg1 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: nsgName1
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
           name: 'SSH'
           properties : {
               protocol : 'Tcp' 
               sourcePortRange :  '*'
               destinationPortRange :  '22'
               sourceAddressPrefix :  '*'
               destinationAddressPrefix: '*'
               access:  'Allow'
               priority : 101
               direction : 'Inbound'
               sourcePortRanges : []
               destinationPortRanges : []
               sourceAddressPrefixes : []
               destinationAddressPrefixes : []
          }
      }
    ]
  }
}
resource nsg2 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: nsgName2
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
           name: 'SSH'
           properties : {
               protocol : 'Tcp' 
               sourcePortRange :  '*'
               destinationPortRange :  '22'
               sourceAddressPrefix :  '*'
               destinationAddressPrefix: '*'
               access:  'Allow'
               priority : 101
               direction : 'Inbound'
               sourcePortRanges : []
               destinationPortRanges : []
               sourceAddressPrefixes : []
               destinationAddressPrefixes : []
          }
      }
    ]
  }
}
output subnetId1 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${subnet1Name}')
output subnetId2 string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, '${subnet2Name}')

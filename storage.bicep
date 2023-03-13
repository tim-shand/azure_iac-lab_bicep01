// =========== storage.bicep ===========
// # Params
param storageName string = 'st'
param location string = resourceGroup().location
param tags object = {
  tagName1: 'tag1'
  tagName2: 'tag2'
}

resource newStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
output storageUri string = newStorage.properties.primaryEndpoints.blob

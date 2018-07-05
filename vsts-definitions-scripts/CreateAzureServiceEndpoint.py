from requests.auth import HTTPBasicAuth
import urllib.parse
import pprint
import requests
import sys
import json

# Script parameters
vsts_intance = sys.argv[1]
project_name = sys.argv[2]
subscription_id = sys.argv[3]
subscription_name = sys.argv[4]
tenant_id = sys.argv[5]
service_principal_id = sys.argv[6]
service_principal_key = sys.argv[7]
endpoint_name = sys.argv[8]
vsts_token = sys.argv[9]

# URL information
vsts_url = vsts_intance + "/"
request_information = project_name + '/_apis/serviceendpoint/endpoints?'
api_version = '4.1-preview.1'

# Request information
headers = {'Content-Type': 'application/json'}
credentials = HTTPBasicAuth('', vsts_token)

# New Endpoint information
new_endpoint = {
    "data": {
        "SubscriptionId": subscription_id,
        "SubscriptionName": subscription_name
    },
    "name": endpoint_name,
    "type": "azurerm", 
    "authorization" : { 
        "parameters": {
            "tenantid": tenant_id,
            "serviceprincipalid": service_principal_id,
            "serviceprincipalkey": service_principal_key
        },
        "scheme": "ServicePrincipal"
    },
    "isReady": "true"
}

# Convert body information to json
new_endpoint = json.dumps(new_endpoint)

# Endpoint creation
response = requests.post(vsts_url + request_information + 'api-version=' + api_version, auth=credentials, headers=headers, data=new_endpoint).json()

# Write response
pprint.pprint(response)
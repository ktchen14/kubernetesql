#! /usr/bin/env python3

import kubernetesql

print('*********** TESTING EXECUTION ***********')

print('\n====== TESTING NODES ======')
wrapper = kubernetesql.initialize_fdw({
    'resource_type': 'nodes',
}, {})
for line in wrapper.execute(None, None):
	print(line)


print('\n====== TESTING DEPLOYMENTS ======')
wrapper = kubernetesql.initialize_fdw({
    'resource_type': 'deployments',
}, {})
for line in wrapper.execute(None, None):
	print(line)


print('\n====== TESTING PODS ======')
wrapper = kubernetesql.initialize_fdw({
    'resource_type': 'pods',
}, {})
for line in wrapper.execute(None, None):
	print(line)


print('\n\n\n*********** TESTING UPDATE ***********')
print('\n====== TESTING DEPLOYMENTS ======')
wrapper = kubernetesql.initialize_fdw({
    'resource_type': 'deployments',
}, {})
wrapper.update('nginx-deployment', { 'name': 'nginx-deployment', 'desired': 4})
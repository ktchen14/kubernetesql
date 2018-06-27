#! /usr/bin/env python3

import kubernetesql

wrapper = kubernetesql.initialize_fdw({
    'resource_type': 'nodes'
}, {})
for line in wrapper.execute(None, None):
	print(line)
# assert list(wrapper.execute(None, None)) == [{'node_name': 'node1'}, {'node_name': 'node2'}]

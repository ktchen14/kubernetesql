#! /usr/bin/env python3

from kubernetesql import KubernetesForeignDataWrapper as KFDW

wrapper = KFDW({}, {})
for line in wrapper.execute(None, None):
	print(line)
# assert list(wrapper.execute(None, None)) == [{'node_name': 'node1'}, {'node_name': 'node2'}]

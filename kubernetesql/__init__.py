from multicorn import ForeignDataWrapper
from kubernetes import client, config
from datetime import datetime, timezone

config.load_kube_config()

class KubeNodeDataWrapper(ForeignDataWrapper):
    def __init__(self, *args):
        super(KubeNodeDataWrapper, self).__init__(*args)
        self.kube = client.CoreV1Api()

    def execute(self, quals, columns):
        result = self.kube.list_node(watch=False)
        now = datetime.now(tz=timezone.utc)

        for i in result.items:
            line = {
                'name': i.metadata.name,
                'age': str(now - i.metadata.creation_timestamp),
                'status': i.status.conditions[-1].type,
                'version': i.status.node_info.kubelet_version
            }
            yield line

def initialize_fdw(options, columns):
    if options['resource_type'] == 'nodes':
        return KubeNodeDataWrapper(options, columns)
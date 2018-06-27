from multicorn import ForeignDataWrapper
from kubernetes import client, config
from datetime import datetime, timezone

config.load_kube_config()

class KubernetesForeignDataWrapper(ForeignDataWrapper):

    def __init__(self, options, columns):
        super(KubernetesForeignDataWrapper, self).__init__(options, columns)
        self.kube = client.CoreV1Api()
        self.columns = columns

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

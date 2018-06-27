from multicorn import ForeignDataWrapper
from multicorn.utils import log_to_postgres
import logging
from kubernetes import client, config
from datetime import datetime, timezone

config.load_kube_config()

def initialize_fdw(options, columns):
    if options['resource_type'] == 'nodes':
        return KubeNodeDataWrapper(options, columns)
    elif options['resource_type'] == 'deployments':
        return KubeDeploymentDataWrapper(options,columns)
    elif options['resource_type'] == 'pods':
        return KubePodDataWrapper(options,columns)

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

class KubeDeploymentDataWrapper(ForeignDataWrapper):
    def __init__(self, *args):
        super(KubeDeploymentDataWrapper, self).__init__(*args)
        self.kube = client.AppsV1beta1Api()

    @property
    def rowid_column(self):
        return 'name'

    def execute(self, quals, columns):
        result = self.kube.list_namespaced_deployment('default', watch=False)
        now = datetime.now(tz=timezone.utc)
        for i in result.items:
            line = {
                'name': i.metadata.name,
                'desired': i.spec.replicas,
                'current_num': i.status.ready_replicas,
                'up_to_date': i.status.updated_replicas,
                'available': i.status.available_replicas,
                'age': str(now - i.metadata.creation_timestamp)
            }
            yield line

    def update(self, name, new_values):
        desired = new_values['desired']
        result = self.kube.patch_namespaced_deployment(name, 'default', { 'spec': { 'replicas': desired }})
        return new_values

class KubePodDataWrapper(ForeignDataWrapper):
    def __init__(self, *args):
        super(KubePodDataWrapper, self).__init__(*args)
        self.kube = client.CoreV1Api()

    def execute(self, quals, columns):
        result = self.kube.list_namespaced_pod('default', watch=False)
        now = datetime.now(tz=timezone.utc)

        for i in result.items:
            container_count = len(i.status.container_statuses)
            ready = 0
            restarts = 0
            for j in i.status.container_statuses:
                if j.ready:
                    ready += 1
                restarts += j.restart_count

            line = {
                'name': i.metadata.name,
                'ready': str(ready) + '/' + str(container_count),
                'status': i.status.phase,
                'restarts': restarts,
                'age': str(now - i.status.start_time)
            }
            yield line

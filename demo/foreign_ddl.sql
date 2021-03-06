DROP EXTENSION IF EXISTS multicorn;
CREATE EXTENSION multicorn;
SET client_min_messages TO 'debug';
DROP SERVER IF EXISTS k8s_wrapper CASCADE;

CREATE SERVER k8s_wrapper FOREIGN DATA WRAPPER multicorn
options (
  wrapper 'kubernetesql.initialize_fdw'
);

DROP FOREIGN TABLE IF EXISTS nodes;

CREATE FOREIGN TABLE nodes (
-- items.metadata.name
    name character varying,
--    items.status.addresses (where type == externalIP)
	external_ip inet,
--    status character varying,
    -- items.metadata.creationTimestamp
    age character varying,
--    items.status.nodeInfo.kubeletVersion
    version character varying
) server k8s_wrapper   options ( resource_type 'nodes');

DROP FOREIGN TABLE IF EXISTS deployments;

CREATE FOREIGN TABLE deployments (
-- items.metadata.name
    name character varying,
--    items.replicas
    desired int,
--    items.readyReplicas
    current_num int,
--    items.updatedReplicas
    up_to_date int,
--    items.availableReplicas
    available int,
    -- items.metadata.creationTimestamp
    age character varying,
    -- items. metadata.annotations
    annotations jsonb
) server k8s_wrapper options (resource_type 'deployments');

DROP FOREIGN TABLE IF EXISTS pods;

CREATE FOREIGN TABLE pods (
-- items.metadata.name
    name character varying,
    -- items.spec.node_name
    node_name character varying,
    -- items.metadata.ownerReference.name (to get ReplicaSet)
      -- items.ownerReference.name (after getting ReplicaSet info to get deployment name)
    deployment_name character varying,
    -- items.spec.containers[x] image
    image_names character varying[],
    -- items.status.containerStatuses.ready == true -- numerator
     -- length( items.status.containerStatuses) -- denominator
    ready character varying,
    -- items.status.phase
    status character varying,
    -- items.status.containerStatuses.restartCount
    restarts int,
    -- items.status.startTime
    age character varying
) server k8s_wrapper options (resource_type 'pods');


-- UPDATE deployments set desired = 3 where name = 'nginx-deployment';
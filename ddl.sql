DROP SERVER IF EXISTS k8s_wrapper CASCADE;

CREATE SERVER k8s_wrapper FOREIGN DATA WRAPPER multicorn
options (
  wrapper 'kubernetesql.initialize_fdw'
);

DROP FOREIGN TABLE IF EXISTS nodes;

CREATE FOREIGN TABLE nodes (
-- items.metadata.name
    name character varying,
--    items.status
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
    age character varying
) server k8s_wrapper options (resource_type 'deployments');

DROP FOREIGN TABLE IF EXISTS pods;

CREATE FOREIGN TABLE pods (
-- items.metadata.name
    name character varying,
    -- items.status.conditions.type where type = Ready
    ready character varying,
    -- items.status.phase
    status character varying,
    -- items.status.containerStatuses.restartCount
    restarts int,
    -- items.status.startTime
    age character varying
) server k8s_wrapper options (resource_type 'pods');

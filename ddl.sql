DROP SERVER IF EXISTS k8s_wrapper CASCADE;

CREATE SERVER k8s_wrapper FOREIGN DATA WRAPPER multicorn
options (
  wrapper 'kubernetesql.KubernetesDataWrapper'
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
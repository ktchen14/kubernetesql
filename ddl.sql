DROP SERVER IF EXISTS k8s_wrapper;

CREATE SERVER k8s_wrapper FOREIGN DATA WRAPPER multicorn
options (
  wrapper 'kubernetesql.KubernetesDataWrapper'
);

DROP FOREIGN TABLE IF EXISTS nodes;

CREATE FOREIGN TABLE nodes (
    test character varying,
    test2 character varying
) server k8s_wrapper;

SELECT pods.name as pod_name, nodes.name as node_name, nodes.external_ip FROM nodes
INNER JOIN pods
ON pods.node_name = nodes.name;

SELECT name, desired, current_num, available, age FROM deployments WHERE name = 'nginx-deployment';
UPDATE deployments SET desired = 5 WHERE name = 'nginx-deployment';
SELECT name, desired, current_num, available, age FROM deployments WHERE name = 'nginx-deployment';

-- get a list of employee emails where the employee is the owner of a deployment impacted by the outage

SELECT DISTINCT deployments.name as deployment_name, employee.name, email FROM employee
INNER JOIN deployments ON employee.user_id::TEXT = annotations->>'user'
INNER JOIN pods ON pods.deployment_name = deployments.name
INNER JOIN cves ON cves.docker_image = ANY(pods.image_names);


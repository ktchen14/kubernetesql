-- get a list of employee emails where the employee is the owner of a deployment impacted by the outage

SELECT DISTINCT name, email FROM employee
INNER JOIN deployments ON employee.user_id::TEXT = annotations->>user_id
INNER JOIN pods ON pods.deployment_name = deployments.name;
--INNER JOIN cves ON cves.docker_image = ANY(pods.docker_images);
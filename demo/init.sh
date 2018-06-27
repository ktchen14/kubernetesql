#! /usr/bin/env bash

kubectl annotate --overwrite deployment nginx-deployment user=1

pushd .. > /dev/null
	python3 setup.py install -f
popd > /dev/null

psql postgres < foreign_ddl.sql
psql postgres < local_ddl.sql

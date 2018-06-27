#! /usr/bin/env bash

pushd .. > /dev/null
	python3 setup.py install -f
popd > /dev/null

psql postgres < foreign_ddl.sql
psql postgres < local_ddl.sql

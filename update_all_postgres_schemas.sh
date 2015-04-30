#!/bin/bash  
echo 'get postgres schema names'
export PGPASSWORD=$4
psql -h $1 -U $2 -d $3 <<EOF
 \o $3_schemalist.txt
 \t on
 SELECT n.nspname FROM pg_catalog.pg_namespace n WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema' AND n.nspname <> 'jss_sys' AND n.nspname <> 'public';
 \o
 \t off
EOF

echo '- removing blank lines'
sed -ie '/^$/d' $3_schemalist.txt
echo '- removing whitespaces'
sed -ie 's/^[ \t]*//' $3_schemalist.txt
echo '- putting double quotes for each schema name'
sed -ie 's/^.*/"&"/' $3_schemalist.txt

echo 'start psql update'
while read p; do
  echo '- updating schema ' $p 
  psql -h $1 -U $2 -d $3 -v schema=$p <<EOF
    SET search_path TO :schema;
    ALTER TABLE test ALTER COLUMN testcolumn TYPE varchar(100);
EOF
done <$3_schemalist.txt
echo  'finished psql update'

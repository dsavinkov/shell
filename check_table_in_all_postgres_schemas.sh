#!/bin/bash  
echo 'get postgres schema names'
export PGPASSWORD=$4
psql -h $1 -U $2 -d $3 <<EOF
 \o $3_schemalist.txt
 \t on
 SELECT n.nspname FROM pg_catalog.pg_namespace n WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema' AND n.nspname <> 'test' AND n.nspname <> 'public';
 \o
 \t off
EOF

echo '- removing blank lines'
sed -ie '/^$/d' $3_schemalist.txt
echo '- removing whitespaces'
sed -ie 's/^[ \t]*//' $3_schemalist.txt
echo '- putting single quotes for each schema name'
sed -ie "s/^.*$/'&'/g" $3_schemalist.txt

echo 'Checking Postgres'
while read p; do
  echo 'Checking schema ' $p 
  psql -h $1 -U $2 -d $3 -v schema=$p -v table=$5 <<EOF
    SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = :schema AND table_name = :table);
EOF
done <$3_schemalist.txt
echo  'Finished Postgres check'

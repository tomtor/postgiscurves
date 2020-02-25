PORT=30779
HOST=localhost
PGU=tom
DB=bgt

for f in *.gml.gz
do
  TAB=$(echo "$f" | sed -e "s/bgt_//" -e "s/\\.gml.*//")
  echo $TAB

  ogr2ogr -f "PostgreSQL" -overwrite -a_srs EPSG:28992 -nlt CONVERT_TO_LINEAR -lco SPATIAL_INDEX=GIST PG:"dbname=$DB host=$HOST port=$PORT" "$f"

  echo "ALTER TABLE public.$TAB CLUSTER ON ${TAB}_wkb_geometry_geom_idx;" | psql -U $PGU -h $HOST -p $PORT $DB

done

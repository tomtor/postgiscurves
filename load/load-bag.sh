PORT=30779
HOST=localhost
PGU=tom
DB=bgt

echo "select 'drop table '||tablename||';' cascade from pg_tables where tablename like 'bag_%'" | \
    psql -U $PGU -h $HOST -p $PORT -d $DB -t | \
    psql -U $PGU -h $HOST -p $PORT -d $DB

for f in *.xml
do
  TAB=$(echo "$f" | sed -e "s/9999PND//" -e "s/\\.xml.*//")
  echo $TAB starts at $(date)

  ogr2ogr -progress -f "PostgreSQL"  -a_srs EPSG:28992 -nlt CONVERT_TO_LINEAR -lco SPATIAL_INDEX=GIST -lco DIM=2 PG:"dbname=$DB host=$HOST port=$PORT" GMLAS:"$f"

  # echo "ALTER TABLE public.$TAB CLUSTER ON ${TAB}_wkb_geometry_geom_idx;" | psql -U $PGU -h $HOST -p $PORT $DB
  echo $TAB ends at $(date)

done

exit 0

  echo "DROP TABLE $TAB;" | psql -U $PGU -h $HOST -p $PORT $DB

  echo "CREATE INDEX ${TAB}_multi ON public.$TAB USING gist (wkb_geometry);" | \
	psql -U $PGU -h $HOST -p $PORT $DB

    echo "CREATE INDEX $f_multi
    ON public.kunstwerkdeel USING gist
    (wkbt_geometry)
    TABLESPACE pg_default;
    ALTER TABLE public.kunstwerkdeel CLUSTER ON kunstwerkdeel_multi;" | psql -U $PGU -h $HOST -p $PORT $DB
    # (geometrie_multivlak, geometrie_lijn, geometrie_multipunt, geometrie_vlak)

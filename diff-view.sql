-- View: public.diffbag

DROP VIEW public.diffbag cascade;

CREATE OR REPLACE VIEW public.diffbag
 AS
 SELECT a.ogc_fid,
    a.gml_id,
    a.objectbegintijd,
    a."identificatie.namespace",
    a."identificatie.lokaalid",
    a.tijdstipregistratie,
    a.eindregistratie,
    a.lv_publicatiedatum,
    a.bronhouder,
    a.inonderzoek,
    a.relatievehoogteligging,
    a.bgt_status,
    a.identificatiebagpnd,
    a."nummeraanduidingreeks_1.tekst",
    a."nummeraanduidingreeks_1.positie_1.hoek",
    a."nummeraanduidingreeks_1.identificatiebagvbolaagstehuisnummer",
    a."nummeraanduidingreeks_1.identificatiebagvbohoogstehuisnummer",
    a.objecteindtijd,
    a."nummeraanduidingreeks_2.tekst",
    a."nummeraanduidingreeks_2.positie_1.hoek",
    a."nummeraanduidingreeks_2.identificatiebagvbolaagstehuisnummer",
    a."nummeraanduidingreeks_2.identificatiebagvbohoogstehuisnummer",
    a."nummeraanduidingreeks_3.tekst",
    a."nummeraanduidingreeks_3.positie_1.hoek",
    a."nummeraanduidingreeks_3.identificatiebagvbolaagstehuisnummer",
    a."nummeraanduidingreeks_3.identificatiebagvbohoogstehuisnummer",
    a.plus_status,
    a.wkb_geometry
   FROM pand a
     JOIN bag_extract_deelbestand__antwoord_producten_lvc_product_pand b ON st_overlaps(a.wkb_geometry, b.pandgeometrie)
  -- WHERE a.eindregistratie IS NULL AND b.tijdvakgeldigheid_einddatumtijdvakgeldigheid IS NULL AND b.aanduidingrecordinactief::text <> 'J'::text AND abs(st_perimeter(a.wkb_geometry) - st_perimeter(b.pandgeometrie)) > 1::double precision;
  WHERE abs(st_perimeter(a.wkb_geometry) - st_perimeter(b.pandgeometrie)) > 1::double precision;

-- ALTER TABLE public.diffbag OWNER TO postgresadmin;

-- GRANT ALL ON TABLE public.diffbag TO postgresadmin;
GRANT ALL ON TABLE public.diffbag TO PUBLIC;


create materialized view diffbagmat as select * from diffbag;

CREATE INDEX diffbagmat_wkb_geometry_geom_idx
    ON public.diffbagmat USING gist (wkb_geometry) TABLESPACE pg_default;

CREATE INDEX diff_ogc_id ON public.diffbagmat USING btree
    (ogc_fid ASC NULLS LAST) INCLUDE(ogc_fid) TABLESPACE pg_default;

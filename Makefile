#TAG=tomtor/postgis:postgis251_11.3_fix
TAG=tomtor/postgis:postgis300trunk_SFCGAL413_12.beta

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

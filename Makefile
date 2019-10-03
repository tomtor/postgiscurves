TAG=tomtor/postgis:postgis300trunk_SFCGAL413_12.0
TAG_ARM=tomtor/postgis:postgis251_1e-1_fix_raster_arm

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

arm:
	docker build -f Dockerfile.arm -t $(TAG_ARM) .

push-arm:
	docker push $(TAG_ARM)

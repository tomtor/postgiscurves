TAG=tomtor/postgis:postgis251_1e-1_fix
TAG_ARM=tomtor/postgis:postgis251_1e-1_fix_arm

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

arm:
	docker build -f Dockerfile.arm -t $(TAG_ARM) .

push-arm:
	docker push $(TAG_ARM)

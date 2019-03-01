TAG=tomtor/postgis:postgis251_1e-1_fix12_tolerance

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

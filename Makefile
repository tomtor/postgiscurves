TAG=tomtor/postgis:postgis251_1e-1_fix11_tolerance

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

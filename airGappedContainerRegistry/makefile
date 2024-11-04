all:
	docker-compose down
	rm data -Rf
	docker-compose up -d
	wget https://github.com/okd-project/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-client-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
	tar -zxvf openshift-client-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
	oc adm release mirror \
	  --from=quay.io/openshift/okd:4.15.0-0.okd-2024-03-10-010116 \
	  --to=localhost:5000/openshift/okd \
	  --to-release-image=localhost:5000/openshift/okd:4.15.0-0.okd-2024-03-10-010116 --skip-verification --insecure
	docker-compose stop
	docker-compose down
	docker build -t okdregistry .

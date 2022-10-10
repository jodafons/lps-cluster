build:
	docker build --network host --compress -t jodafons/caloba:latest .
	docker build --network host --compress -t jodafons/caloba:tensorflow .
push:
	docker push jodafons/caloba:latest
	docker push jodafons/caloba:tensorflow

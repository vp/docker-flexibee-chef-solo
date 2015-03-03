# docker-flexibee-chef-solo
Flexibee docker image

Docker image with Abra Flexibee installation

1. build image:

  docker build -t vp/flexibee .

2. run container:

  docker run -P -p=5435:5435 -p=5434:5434 -t -i --name flexibee vp/flexibee

3. use:

  flexibee will be avaible on: 
  172.17.42.1:5434
  
  postgresql on:
  172.17.42.1:5435

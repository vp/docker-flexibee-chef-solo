# Flexibee docker image

Installs and setup postgres, java and Abra Flexibee server using chef solo on debian wheezy.

*This image is mean for development and testing purposes. It's setup does not care about security etc...*

Configure/Customize
-------------------

Database passwords etc. can by modified in chef/solo.json


Building image
-----------

    docker build -t vp/flexibee .
    
You can change image name (vp/flexibee) to whotever you want

Running container
-----------------

    docker run -t -i -P -p=5435:5435 -p=5434:5434 --name flexibee vp/flexibee
    
Runs container with given name (flexibee) and exposes postgres and flexibee server port to host system

To run on background use

    docker run -d -P -p=5435:5435 -p=5434:5434 --name flexibee vp/flexibee
   
To stop container use

    docker stop flexibee
    
To remove container use

    docker rm flexibee

flexibee server will be avaible on: 
     
    172.17.42.1:5434
  
postgresql on:
  
    172.17.42.1:5435

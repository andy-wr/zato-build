Steps needed to succefully run Zato distributed environment, Docker based on Amazon Elastic Beanstalk platform.

Steps are almost same as building distributed environment with Docker na Linux systems - with little additions.
Source: https://https://zato.io/docs/admin/guide/install-docker-dist.html

First, You have to provide postgresql and redis services (i.e. create ubuntu instance with postgres and redis - or another beanstalk app 
with db and redis) and certificates.
Every component will work as separate beanstalk only as single instance application (it's important during beanstalk creation setup).
Plan Your components connections by DNS names specified in beanstalk creation setup - You don't know what IP adresses You get.
You can also use EC2 VPC.
Prepare zip files needed for aplication deployment:
1. Download and prepare all config files scripts and Dockerfiles for all components - odbcluster, webadmin, loadbalancer, server1 and server2 
   (https://https://zato.io/docs/admin/guide/install-docker-dist.html)

2. Download Elastic Benastalk two scripts:
(links here)
- eb_iptables.config (changing default iptables policies and let connect to docker container on more than one port)
- eb_swap.config (adds more swap to system - if You plan enough RAM for EC2 instance (more than 1,5GB) 
  and You think that it's not needed for You environment - just remove this script)

3. In all component catalogs create catalog .ebextensions - dot is important!

4. Copy to all components into .ebextensions this two downloaded eb configs (step 2)

5. Create zip file for every component - example for loadbalancer:
(linux command line)
$ zip zato_loadbalancer.zip zato.load_balancer.cert.pem zato.load_balancer.key.pem zato.load_balancer.key.pub.pem \ 
                            ca_cert.pem zato_load_balancer.config Dockerfile .ebextensions/eb_iptables.config .ebextensions/eb_swap.config

Repeat this step for all components - don't forget about certificates and config files parametrization

3. Deploy all Amazon Beanstalk components with prepared zip's from i.e. Amazon web services

4. To connect all in one You have to switch to EC2/Instances panel and for every instance (which correspond to beanstalk application) add propper security group what let You make possible conncet all components together (network).

5. Get webadmin password:
   - login via ssh to EC2 instance with key specified during beanstalk proccess creation
   - get docker id:
     $ sudo docker ps
   - run command to get zato user and web admin passwords:
     $ sudo docker exec -it <containerIdOrName> /bin/bash -c 'cat /opt/zato/web_admin_password \
        /opt/zato/zato_user_password'

6. Enjoy...
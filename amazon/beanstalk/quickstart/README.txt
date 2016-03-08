Steps needed to succefully run Zato Quickstart on Amazon Elastic Beanstalk platform.

1. Download Dockerfile - https://zato.io/download/docker/quickstart/Dockerfile

2. Download Elastic Benastalk two scripts:

3. In catalog i.e quickstart create catalog .ebextensions - dot is important!

4. Copy into .ebextensions this two downloaded eb configs (step 2)
(links here)
- eb_iptables.config (changing default iptables policies and let connect to docker container on more than one port)
- eb_swap.config (adds more swap to system - if You plan enough RAM for EC2 instance (more than 1,5GB)
  and You think that it's not needed for You environment - just remove this script)

5. Zip Dockrefile with .ebextensions
eg:
$ zip zato_quickstart.zip Dockerfile .ebextensions/eb_iptables.config .ebextensions/eb_swap.config

6. From Amazon web service, create beanstalk Docker single instance environment

7. Deploy application with zip created before

8. Wait

9. From EC2 console choose Instances and add security group that cover Your needs to access Zato Quickstart

10. Get webadmin password:
   - login via ssh to EC2 instance with key specified during beanstalk proccess creation
   - get docker id:
     $ sudo docker ps
   - run command to get zato user and web admin passwords:
     $ sudo docker exec -it <containerIdOrName> /bin/bash -c 'cat /opt/zato/web_admin_password \
        /opt/zato/zato_user_password'

11. Enjoy...

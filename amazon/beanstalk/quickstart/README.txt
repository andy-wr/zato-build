Steps needed to succefully run Zato Quickstart on Amazon Elastic Beanstalk platform.

1. Zip Dockrefile with .ebextension
eg:
$ zip zato_quickstart.zip Dockerfile .ebextensions/eb_iptables.config .ebextensions/eb_swap.config

2. From Amazon web service, create beanstalk single instance environment

3. Deploy application with zip created before

4. Wait

5. From EC2 console choose Instances and add security group that cover Your needs to access Zato Quickstart

6. Get webadmin password:
   - login via ssh to EC2 instance with key specified during beanstalk proccess creation
   - get docker id:
     $ sudo docker ps
   - run command to get zato user and web admin passwords:
     $ sudo docker exec -it <containerIdOrName> /bin/bash -c 'cat /opt/zato/web_admin_password \
        /opt/zato/zato_user_password'

7. Enjoy...
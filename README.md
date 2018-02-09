### php_nginx_jenkins

# Vagrant Machine

Run the following commands to clone the repository and create/run the vagrant machine.

```shell
git clone https://github.com/behestee/php_nginx_jenkins.git
cd php_nginx_jenkins
vagrant up
```



# EC2 Machine setup

Create your EC2 machine and follow the steps:

1. After download the pem file make it ready to use. run the following command

```shell
chmod 600 .ssh/myec2.pem 
```

2. Connect to server through ssh
```shell
ssh -i .ssh/myec2.pem ubuntu@ip
```

3. Prepare for serversetup

```shell
git clone https://github.com/behestee/php_nginx_jenkins.git
cd php_nginx_jenkins
chmod +x setup_aws.sh
sudo ./setup_aws.sh
```

4. Modify Domain Name as necessary:

Change domain name in nginx vhost configuaration
```shell
sudo vim  /etc/nginx/sites-available/nginx_vhost
```

Change domain name in hosts file
```shell
sudo vim /etc/hosts
```

5. Resatart server
```shell
sudo service nginx restart
```

6. Know nginx status
```shell
sudo service nginx status
```

7. Get First Password for Jenkins and Configure for Project

```shell
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

8. Browse the domain `http://ipOrDomain:8080` and configure the site





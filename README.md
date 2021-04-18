# webapp
<h3>Sample WebApp to Deploy</h3>
<br>
<h4>AWS Console</h4>
![alt text](https://github.com/sarthakSharma5/webapp/blob/master/Screenshot%20(653).png?raw=true)
<br>
<h4>WebPage output</h4>
![alt text](https://github.com/sarthakSharma5/webapp/blob/master/Screenshot%20(654).png?raw=true)
<br>
<h4>Workflow:</h4>
<pre>

A. Launch EC2 instance with Security Group allowing SSH on Port 22 and HTTP on Ports 80 and 85
  Login to the instance using the Public Key and Enter the following commands :-
    sudo yum update
    sudo yum install httpd
    sudo amazon-linux-extras install docker
    sudo systemctl start httpd
    sudo systemctl start docker
    sudo systemctl enable httpd
    sudo systemctl enable docker
    sudo usermod -a -G docker ec2-user
    sudo mkdir /ws
    sudo chown ec2-user /home/ec2-user/ws
    sudo yum install java-1.8.0-openjdk

B. Add the Instance Worker Node
  Navigate to Manage Nodes / New Node : Name = AWS-MDHack
    Number of executors = 1
    Remote root directory = /ws
    labels = [ aws webserver mayadata ]
    Usage: Only build jobs with label expressions matching this node
    Launch Method : Launch Nodes via SSH
      Host = Public IP of Instance
      Credentials = Add ( ec2-user _ key )
      Host Verification = Non-verifying
  Save -> Launch Node


C. Create Pipeline Project in Jenkins
  Set Build Trigger : Trigger build remotely
    Pipeline
      Script from SCM
        Git : https://github.com/sarthakSharma5/webapp.git
        Branch : master
        Script Path: Jenkinsfile

</pre>


# Building the Containers

From the root directory of this repository, run:

```bash
docker build --tag=r-base -f ./R/R-base.Dockerfile ./R
```

```bash
docker build --tag=r-base-jupyter --tag=kthohr/r-base-jupyter -f ./R/R-base-jupyter.Dockerfile ./R
```

(This includes an extra tag to push the container to Docker Hub.)

# Running the Containers

```bash
docker run -it --rm r-base
```

```bash
docker run -it --rm -p 8888:8888 -v <your/local/folder>:<your/container/folder> r-base-jupyter
```

# Running a Container on EC2 and Connecting to the Instance via a Browser

The following steps describe how to connect to a Jupyter Lab kernel running inside a Docker container that's hosted on an EC2 machine that's running Amazon Linux 2. Standard launch options for the instance apply, except when configuring the Instance Security Group, be sure to add a `Custom TCP Rule` for port `8888` with source `0.0.0.0/0`.

From the EC2 instance, first ensure that Docker is [installed correctly](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html):

```bash
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
```

After logging out and back into the instance, pull the image from Docker Hub:

```bash
docker pull kthohr/r-base-jupyter
```

Start the container using:

```bash
mkdir -p ~/docker_shared_folder
cd ~/docker_shared_folder
docker run -it --rm -p 8888:8888 -v /home/ec2-user/docker_shared_folder:/root/shared_folder kthohr/r-base-jupyter
```

From within the container:

```bash
cd /root/shared_folder
jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```

On your **local machine**:

* modify `~/.ssh/config` to include:

```
Host ec2
   Hostname <aws-ec2-instance-public-ip-address>
   User ec2-user
   IdentityFile <path/to/your/.pem/file>
```

* set up port forwarding:

```bash
ssh -NfL 8900:localhost:8888 ec2
```

Finally, connect to the container from your browser (replacing with the full token):

```bash
http://localhost:8900/lab?token=<token>
```

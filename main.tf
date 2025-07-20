# Define the AWS provider configuration
provider "aws" {
  region = "ap-south-1"                      # Specify the AWS region to deploy resources
}

# CIDR Variable 
variable "cidr" {
  default = "10.0.0.0/16"                       # Default CIDR block for the VPC
}

# Creating the key file
resource "aws_key_pair" "example" {
    key_name = "terraform-demo-biswal"           # Replace with your desired key name for the key pair
    public_key = file("~/.ssh/id_rsa.pub")   # Path to your public key file for SSH access
}

# Define the VPC
resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr                        # Use the CIDR variable defined above for the VPC's address space
}

# Define the Subnet 
resource "aws_subnet" "sub1" {
    vpc_id            = aws_vpc.myvpc.id          # Associate the subnet with the VPC
    cidr_block        = "10.0.0.0/24"             # CIDR block for the subnet
    availability_zone = "ap-south-1a"              # Specify the availability zone for the subnet
    map_public_ip_on_launch = true                # Automatically assign public IPs to instances launched in this subnet
}

# Define Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id                     # Attach the internet gateway to the VPC
}

# Route Table
resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id                    # Associate the route table with the VPC

    route {
        cidr_block = "0.0.0.0/0"                  # Route all outbound traffic to the internet
        gateway_id = aws_internet_gateway.igw.id  # Use the internet gateway for the route
    }
}

# Route Table association
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id                # Associate the subnet with the route table
    route_table_id = aws_route_table.RT.id        # Specify the route table to associate
}


# Define Security Group
resource "aws_security_group" "webSg" {
    name = "web"                                  # Name of the security group
    vpc_id = aws_vpc.myvpc.id                     # Associate the security group with the VPC


    # Ingress rule for HTTP traffic
    ingress {
        description = "HTTP from VPC"            # Description of the rule
        from_port   = "80"                       # Starting port for the rule
        to_port     = "80"                       # Ending port for the rule
        protocol    = "tcp"                      # Protocol for the rule (TCP)
        cidr_blocks = ["0.0.0.0/0"]              # Allow traffic from any IP address
    }


    # Ingress rule for SSH traffic
    ingress {
        description = "SSH from VPC"            # Description of the rule
        from_port   = "22"                      # Starting port for the rule
        to_port     = "22"                      # Ending port for the rule
        protocol    = "tcp"                     # Protocol for the rule (TCP)
        cidr_blocks = ["0.0.0.0/0"]             # Allow traffic from any IP address
    }

    # Egress rule to allow all outbound traffic
    egress {
        from_port   = 0                         # Starting port (0 means all ports)
        to_port     = 0                         # Ending port (0 means all ports)
        protocol    = "-1"                      # Protocol (-1 means all protocols)
        cidr_blocks = ["0.0.0.0/0"]             # Allow outbound traffic to any IP address
    }

    tags = {
        Name = "Web-SG"                         # Tag for the security group
    }
}

# Define EC2 Instance
resource "aws_instance" "server" {
    ami             = "ami-0f918f7e67a3323f0"                   # AMI ID for the instance
    instance_type   = "t2.micro"                                # Instance type
    key_name        = aws_key_pair.example.key_name             # Use the key pair for SSH access
    vpc_security_group_ids = [aws_security_group.webSg.id]      # Associate the security group with the instance
    subnet_id       = aws_subnet.sub1.id                        # Place the instance in the specified subnet

    tags = {
      Name = "developer-server1"
    }

   # Connection block for SSH access
    connection {
      type        = "ssh"                       # Connection type
      user        = "ubuntu"                    # Username for the EC2 instance
      private_key = file("~/.ssh/id_rsa")   # Path to the private key for SSH access
      host        = self.public_ip              # Use the public IP of the instance for SSH
      timeout     = "10m"
    }

    # File provisioner to copy a file from local to the remote EC2 instance
    provisioner "file" {
        source = "app.py"                      # Path to the local file to copy
        destination = "/home/ubuntu/app.py"    # Path on the remote instance where the file will be copied
    }


    # Remote-exec provisioner to run commands on the remote EC2 instance
    provisioner "remote-exec" {
        inline = [
            "echo 'Hello from the remote instance'",    # Print a message to the console
            "sudo apt update -y",                       # Update package lists (for Ubuntu)
            "sudo apt-get install -y python3-pip",      # Install Python package manage
            "cd /home/ubuntu",                          # Change directory to the home folder
            "sudo pip3 install flask",                  # Install Flask web framework
            "sudo python3 app.py &",                    # Run the application in the background
        ]
    }
}
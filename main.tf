provider "aws"{
    region="ap-south-1"
}
resource "aws_instance" "example"{
    ami="ami-03f4878755434977f"
    instance_type="t2.micro"
    vpc_security_group_ids=[aws_security_group.instance.id]
    

    user_data=<<-EOF
              #!/bin/bash
              echo "Hello,sukers" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
                
    user_data_replace_on_change=true

    tags={
        Name="terraform-example"
    }
}

resource "aws_security_group" "instance"{
    name="terraform-example-instance"

    ingress{
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }

    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]

    }
}

output "public_ip" {
    value = aws_instance.example.public_ip
}
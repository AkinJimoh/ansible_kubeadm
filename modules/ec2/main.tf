// resource "aws_instance" "master" {
//   count                       = 1
//   ami                         = "ami-0ad8ecac8af5fc52b"
//   instance_type               = "t2.xlarge"
//   key_name                    = "awsky"
//   vpc_security_group_ids      = [module.vpc.sg-id]
//   subnet_id                   = element(module.vpc.public_subnet_id, 0)
//   associate_public_ip_address = true

//   root_block_device {
//     volume_size           = 50
//     delete_on_termination = true
//   }

//   tags = {
//     Name = "Master"
//   }
// }

// resource "aws_instance" "worker" {
//   count                       = 2
//   ami                         = "ami-0ad8ecac8af5fc52b"
//   instance_type               = "t2.xlarge"
//   key_name                    = "awsky"
//   vpc_security_group_ids      = [module.vpc.sg-id]
//   subnet_id                   = element(module.vpc.public_subnet_id, count.index)
//   associate_public_ip_address = true

//   root_block_device {
//     volume_size           = 50
//     delete_on_termination = true
//   }

//   tags = {
//     Name = "Worker-${count.index + 1}"
//   }
// }
// data "template_file" "init_script" {
//   template = file("${path.module}/data.sh")
// }

resource "aws_launch_template" "cluster" {
  name                   = "cluster"
  instance_type          = "t2.medium"
  user_data              = filebase64("${path.module}/data.sh")
  key_name               = "awsky"
  vpc_security_group_ids = var.vpc_sg_id
  image_id               = "ami-0ad8ecac8af5fc52b"
}


resource "aws_autoscaling_group" "master" {
  name     = "master-asg"
  max_size = 1
  min_size = 1

  launch_template {
    id      = aws_launch_template.cluster.id
    version = "$Latest"
  }

  vpc_zone_identifier = [element(var.public_subnet, 0), element(var.public_subnet, 1)]

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "master-node"
        "propagate_at_launch" = true
      },
    ],
    var.extra_tags,
  )
}

// resource "aws_autoscaling_group" "worker" {
//   count    = 2
//   name     = "worker-asg-${count.index + 1}"
//   max_size = 1
//   min_size = 1
//   launch_template {
//     id      = aws_launch_template.cluster.id
//     version = "$Latest"
//   }
//   vpc_zone_identifier = [element(var.public_subnet, 0), element(var.public_subnet, 1)]

//   tags = concat(
//     [
//       {
//         "key"                 = "Name"
//         "value"               = "worker-node"
//         "propagate_at_launch" = true
//       },
//     ],
//     var.extra_tags,
//   )
// }
provider "aws" {
  region = "us-east-1"
}

resource "aws_ebs_volume" "stackrox_ebs" {
  availability_zone = "us-east-1a"
  size              = 150
  type              = "gp2"
}

# EFS File System
# Language: terraform
resource "aws_efs_file_system" "stackrox_efs" {
  creation_token   = "stackrox-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
}


output "aws_ebs_volume_id" {
  value = aws_ebs_volume.stackrox_ebs.id
}

output "efs_id" {
  value = aws_efs_file_system.stackrox_efs.id
}

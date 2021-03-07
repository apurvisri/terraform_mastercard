# Example of a string variable
variable network_cidr {
  default = "192.168.100.0/24"
}

# Example of a list variable
variable availability_zones {
  default = ["ap-south-1a", "ap-south-1b"]
}

# Example of an integer variable
variable instance_count {
  default = 2
}

# Example of a map variable
variable ami_ids {
default = {
    "ap-south-1" = "ami-0eeb03e72075b9bcc"
  }
}


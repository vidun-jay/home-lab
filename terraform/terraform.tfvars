# Non-sensitive Terraform Configuration

# Oracle Cloud region
region = "ca-montreal-1"

# Paths to keys
private_key_path    = "~/.oci/oci_api_key.pem"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

# Network Configuration
home_public_ip       = ""
minecraft_backend_ip = ""

# Instance configuration
instance_shape      = "VM.Standard.E2.1.Micro"
instance_ocpus      = 1
instance_memory_gb  = 1
boot_volume_size_gb = 50
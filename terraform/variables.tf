# Oracle Cloud Infrastructure Configuration Variables

variable "tenancy_ocid" {
  description = "OCID of your Oracle Cloud tenancy"
  type        = string
  sensitive   = true
}

variable "user_ocid" {
  description = "OCID of the user for API access"
  type        = string
  sensitive   = true
}

variable "fingerprint" {
  description = "Fingerprint of the public key used for API access"
  type        = string
  sensitive   = true
}

variable "private_key_path" {
  description = "Path to the private key file for API access"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  description = "Oracle Cloud region"
  type        = string
  default     = "us-ashburn-1"
}

variable "compartment_ocid" {
  description = "OCID of the compartment to create resources in"
  type        = string
  sensitive   = true
}

# SSH Configuration
variable "ssh_public_key_path" {
  description = "Path to SSH public key for instance access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Network Configuration
variable "home_public_ip" {
  description = "Your home public IP address for SSH access"
  type        = string
}

variable "minecraft_backend_ip" {
  description = "Your home public IP where Minecraft server is running"
  type        = string
}

# Instance Configuration
variable "instance_shape" {
  description = "Shape of the Oracle Cloud instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  description = "Number of OCPUs for the instance"
  type        = number
  default     = 1
}

variable "instance_memory_gb" {
  description = "Memory in GB for the instance"
  type        = number
  default     = 6
}

variable "boot_volume_size_gb" {
  description = "Boot volume size in GB"
  type        = number
  default     = 50
}
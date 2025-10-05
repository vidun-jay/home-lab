# Virtual Cloud Network
resource "oci_core_vcn" "minecraft_proxy_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "minecraft-proxy-vcn"
  dns_label      = "mcproxyvcn"

  freeform_tags = {
    "Purpose" = "minecraft-reverse-proxy"
    "Environment" = "production"
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "minecraft_proxy_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.minecraft_proxy_vcn.id
  display_name   = "minecraft-proxy-igw"
  enabled        = true

  freeform_tags = {
    "Purpose" = "minecraft-reverse-proxy"
  }
}

# Route Table
resource "oci_core_route_table" "minecraft_proxy_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.minecraft_proxy_vcn.id
  display_name   = "minecraft-proxy-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.minecraft_proxy_igw.id
  }

  freeform_tags = {
    "Purpose" = "minecraft-reverse-proxy"
  }
}

# Security List
resource "oci_core_security_list" "minecraft_proxy_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.minecraft_proxy_vcn.id
  display_name   = "minecraft-proxy-security-list"

  # Outbound rules
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # SSH access from your home IP
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "${var.home_public_ip}/32"
    
    tcp_options {
      min = 22
      max = 22
    }
  }

  # SSH access from the starbucks I'm currently deploying this from
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "98.252.92.58/32"
    
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Minecraft proxy port - open to the world
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    
    tcp_options {
      min = 25565
      max = 25565
    }
  }

  # ICMP for ping
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
  }

  freeform_tags = {
    "Purpose" = "minecraft-reverse-proxy"
  }
}

# Subnet
resource "oci_core_subnet" "minecraft_proxy_subnet" {
  cidr_block                 = "10.0.1.0/24"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.minecraft_proxy_vcn.id
  display_name               = "minecraft-proxy-subnet"
  dns_label                  = "mcproxysubnet"
  availability_domain        = data.oci_identity_availability_domains.ads.availability_domains[0].name
  route_table_id             = oci_core_route_table.minecraft_proxy_rt.id
  security_list_ids          = [oci_core_security_list.minecraft_proxy_sl.id]
  prohibit_public_ip_on_vnic = false

  freeform_tags = {
    "Purpose" = "minecraft-reverse-proxy"
  }
}
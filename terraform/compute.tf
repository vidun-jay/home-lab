# Cloud-init script to set up the Minecraft reverse proxy
locals {
  cloud_init_script = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    minecraft_backend_ip = var.minecraft_backend_ip
  }))
}

# Compute Instance
resource "oci_core_instance" "minecraft_proxy" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "minecraft-reverse-proxy"
  shape               = var.instance_shape

  # Shape configuration for flexible shapes
  dynamic "shape_config" {
    for_each = length(regexall("Flex", var.instance_shape)) > 0 ? [1] : []
    content {
      ocpus         = var.instance_ocpus
      memory_in_gbs = var.instance_memory_gb
    }
  }

  # Instance options
  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  # Source details
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_gb
  }

  # Network configuration
  create_vnic_details {
    subnet_id        = oci_core_subnet.minecraft_proxy_subnet.id
    display_name     = "minecraft-proxy-vnic"
    assign_public_ip = true
    hostname_label   = "minecraft-proxy"
  }

  # SSH key
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data          = local.cloud_init_script
  }

  freeform_tags = {
    "Purpose"     = "minecraft-reverse-proxy"
    "Environment" = "production"
    "ManagedBy"   = "terraform"
  }

  timeouts {
    create = "10m"
  }
}
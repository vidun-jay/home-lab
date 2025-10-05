# Outputs
output "instance_public_ip" {
  description = "Public IP address of the Minecraft proxy instance"
  value       = oci_core_instance.minecraft_proxy.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the Minecraft proxy instance"
  value       = oci_core_instance.minecraft_proxy.private_ip
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh ubuntu@${oci_core_instance.minecraft_proxy.public_ip}"
}

output "minecraft_endpoint" {
  description = "Minecraft server endpoint (point your DNS here)"
  value       = "${oci_core_instance.minecraft_proxy.public_ip}:25565"
}

output "management_commands" {
  description = "Useful management commands"
  value = {
    check_status    = "ssh ubuntu@${oci_core_instance.minecraft_proxy.public_ip} 'cd /opt/minecraft-proxy && sudo docker-compose ps'"
    check_logs      = "ssh ubuntu@${oci_core_instance.minecraft_proxy.public_ip} 'cd /opt/minecraft-proxy && sudo docker-compose logs'"
    update_backend  = "ssh ubuntu@${oci_core_instance.minecraft_proxy.public_ip} 'sudo /opt/minecraft-proxy/update-backend-ip.sh NEW_IP_HERE'"
  }
}
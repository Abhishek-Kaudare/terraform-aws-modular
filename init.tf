data "template_file" "client" {
  template = file("./user_data/startup_script.sh")
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    sudo echo 'instance_target_host="${module.rds.rds_address}"' > /opt/server_ip
    EOF
  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}

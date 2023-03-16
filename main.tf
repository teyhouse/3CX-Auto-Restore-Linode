terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

#API-Token
provider "linode" {
  token = var.token 
}

#Basic-Firewall
resource "linode_firewall" "Basic" {
  label = "Basic"

  #HTTP
  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  #HTTPS
  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }

  #Tunnel
  inbound {
    label    = "allow-tunnel"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5090"
    ipv4     = ["0.0.0.0/0"]
  }
  
  #DTS
  inbound {
    label    = "allow-dts-sip"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5060"
    ipv4     = ["92.60.208.0/22"]
  }
  
  #DTS
  inbound {
    label    = "allow-dts-rtp"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "5060"
    ipv4     = ["92.60.208.0/22"]
  }

  #RTP-GLOBAL
  inbound {
    label    = "allow-rtp-global"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "9000-10999"
    ipv4     = ["0.0.0.0/0"]
  }

  #Test-VM
  inbound {
    label    = "allow-tcp-testvm"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["77.12.231.169/32"]
  }

  inbound {
    label    = "allow-udp-testvm"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1-65535"
    ipv4     = ["77.12.231.169/32"]
  }

  inbound_policy = "DROP"
  outbound_policy = "ACCEPT"

  linodes = linode_instance.pbx[*].id
  
}

#3CX Instance
resource "linode_instance" "pbx" {
	  count = length(var.pbx_instances)
    label = var.pbx_instances[count.index]
	
    image = "linode/debian10"
    region = "eu-central"
    type = "g6-nanode-1"

    authorized_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCww0PWD4UhNK7SzvhCOouHJlwJ5nSL/br1GEuFcMlsgiYw+CDzXZN3Q3Hqwq7iiQU/fxX6Dcjm0SOh1QfuCzsJsqX23KHW+USjlSW3kM2W4I4cQadkw5te3d4qa3ydjDJ0EMg4nZk6skmhVEBpgloup58W9yr5sBkLBLMdWllW/WTieJ0cM5ipym4RFaomeZ1CS8UZNThpYlnuQzCKhx6kxFxzDssbYGBaZCNfrl2hK9r8dW7SOPkH7C7UnpbZn0xpfexuAJpPJq+rbjBA5i7RjNTVxFBL7tM0dQKrNQSt0uHvkdfooP3IYq72ILPCk6vOASKkER02BkJxGZwSA/vMUURb5S2tipH6VEoUVRGeX+7JYC9opdWYjgYvlLdo1jZfK/h+Am15TbK/bcgsqZEXBOfGjsIoSES5nzesfgGCvRZt6UePTORHBptwE41DhKNPrG1BuiDVJ4zbUo8N2b1r0i09zIpbk+WtkQGjGSMzF10YrEVfKxP6j7TNP8Qf5H8= teyhouse@TEYHOUSE-PC",
    ]

    root_pass = "you-should-change-this"
    swap_size = 256
    private_ip = true

    provisioner "local-exec" {
      command = "sleep 60; ANSIBLE_PYTHON_INTERPRETER=auto_silent ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ip_address},' --extra-vars \"pbx='${self.label}'\" restore.yaml"
    }

}

output "all_instance_ips" {
  value       = linode_instance.pbx[*].ip_address
  description = "The IPs for all 3CX-Instances"
}
variable "pm_api_url"          { type = string }
variable "pm_tls_insecure"     { type = bool }
variable "pm_user"             { type = string }
variable "pm_password"         { type = string }
variable "pm_api_token_id"     { type = string }
variable "pm_api_token_secret" { type = string }

terraform {
  required_providers {
      proxmox = {
          source  = "telmate/proxmox"
          version = "3.0.1-rc3"
      }
  }
}

variable "vm_data" {
  type = list(object({
    ip   = string
    name = string
    id   = string
  }))

  default = [
    {
      ip   = "10.99.99.176"
      name = "24060121140176-FERNANDA.GALIH.SAPUTRA"
      id   = "24060121140176"
    },
    {
      ip   = "10.99.99.4"
      name = "24060122120004-ABISATYA.HASTARANGGA.PRADANA"
      id   = "24060122120004"
    },
    {
      ip   = "10.99.99.5"
      name = "24060122120005-ADITYA.HAIDAR.FAISHAL"
      id   = "24060122120005"
    },
    {
      ip   = "10.99.99.12"
      name = "24060122120012-FAISHAL.BARIQ.MAULANA"
      id   = "24060122120012"
    },
    {
      ip   = "10.99.99.13"
      name = "24060122120013-RANIA"
      id   = "24060122120013"
    },
    {
      ip   = "10.99.99.19"
      name = "24060122120019-GHIRSAN.AHDANI"
      id   = "24060122120019"
    },
    {
      ip   = "10.99.99.25"
      name = "24060122120025-DIMAS.YUDHA.SAPUTRA"
      id   = "24060122120025"
    },
    {
      ip   = "10.99.99.26"
      name = "24060122120026-TIARA.PUTRI.WIBOWO"
      id   = "24060122120026"
    },
    {
      ip   = "10.99.99.30"
      name = "24060122120030-BERNARDO.NANDANIAR.SUNIA"
      id   = "24060122120030"
    },
    {
      ip   = "10.99.99.34"
      name = "24060122120034-DZU.SUNAN.MUHAMMAD"
      id   = "24060122120034"
    },
    {
      ip   = "10.99.99.35"
      name = "24060122120035-ABDUL.MAJID"
      id   = "24060122120035"
    },
    {
      ip   = "10.99.99.49"
      name = "24060122130049-SYAKIRA.NADA.NIRWANA"
      id   = "24060122130049"
    },
    {
      ip   = "10.99.99.52"
      name = "24060122130052-MUHAMMAD.REYNALDI.AKBAR"
      id   = "24060122130052"
    },
    {
      ip   = "10.99.99.55"
      name = "24060122130055-ASYSYIFA.SHABRINA.MUNIR"
      id   = "24060122130055"
    },
    {
      ip   = "10.99.99.59"
      name = "24060122130059-ARIFIN.NURMUHAMMAD.HARIS"
      id   = "24060122130059"
    },
    {
      ip   = "10.99.99.68"
      name = "24060122130068-MOHAMAD.FAISAL.RIZKI"
      id   = "24060122130068"
    },
    {
      ip   = "10.99.99.69"
      name = "24060122130069-YAHYA.ILHAM.RIYADI"
      id   = "24060122130069"
    },
    {
      ip   = "10.99.99.79"
      name = "24060122130079-SULTAN.ALAMSYAH.BORNEO.ARIFIN"
      id   = "24060122130079"
    },
    {
      ip   = "10.99.99.93"
      name = "24060122130093-NADIVA.AULIA.INAYA"
      id   = "24060122130093"
    },
    {
      ip   = "10.99.99.42"
      name = "24060122140042-MUHAMMAD.FAKHRELL.ANDREAZ"
      id   = "24060122140042"
    },
    {
      ip   = "10.99.99.103"
      name = "24060122140103-MUFLIH.MUHAMMAD.IMADUDDIN"
      id   = "24060122140103"
    },
    {
      ip   = "10.99.99.104"
      name = "24060122140104-ALWEY.HAKIM"
      id   = "24060122140104"
    },
    {
      ip   = "10.99.99.124"
      name = "24060122140124-RONA.REALITA.NAJMA"
      id   = "24060122140124"
    },
  ]
}

provider "proxmox" {
  pm_debug            = true
  pm_api_url          = var.pm_api_url
  pm_tls_insecure     = var.pm_tls_insecure
  pm_user             = var.pm_user
  pm_password         = var.pm_password
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

resource "proxmox_vm_qemu" "generate-automated-vm" {
  for_each    = { for idx, vm in var.vm_data : idx => vm }

  vmid        = 13000 + each.key
  name        = each.value.name
  tags        = "generated_pbp_d2"
  target_node = "pve"

  clone       = "base-debian-ci"
  full_clone  = false

  os_type     = "cloud-init"
  //storage     = "pve-simple-sata-ssd"

  sockets     = 1
  cores       = 4
  memory      = 1024

  ciuser      = each.value.id
  cipassword  = each.value.id

  ipconfig0   = format("gw=10.0.0.1,ip=%s/8", each.value.ip)

  scsihw      = "virtio-scsi-pci"
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "lvm-thinpool-sata-ssd-0"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size = "8G"
          discard            = true
          emulatessd         = true
          storage = "lvm-thinpool-sata-ssd-0"
        }
      }
    }
  }

}
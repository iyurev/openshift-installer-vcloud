provider "vcd" {
  user                 = local.vcdUser
  password             = var.vcd_pass
  org                  = local.vcdOrg
  url                  = local.vcdUrl
  vdc                  = local.vcdVdcName
  allow_unverified_ssl = true
}

resource "vcd_vapp_vm" "bootstrap_vm" {
  for_each = local.bootStrapMachines
  vapp_name = local.vappName
  name = each.key
  catalog_name = local.catalogName
  template_name = local.templateName
  memory =  each.value["ram"]
  cpus = each.value["cpu"]
  cpu_cores = each.value["cpu"]

  network {
    type               = var.network_type
    name               = local.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
    guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.bootstrap_vm_ingition[each.key].rendered)
  }
  depends_on = [
    null_resource.cluster-init
  ]
}

resource "vcd_vapp_vm" "masters_vms" {
  for_each = local.mastersMachines
  vapp_name = local.vappName
  name = each.key
  catalog_name = local.catalogName
  template_name = local.templateName
  memory =  each.value["ram"]
  cpus = each.value["cpu"]
  cpu_cores = each.value["cpu"]

  network {
    type               = var.network_type
    name               = local.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.master_vm_ingition[each.key].rendered)
  }
  depends_on = [
       vcd_vapp_vm.bootstrap_vm
  ]
}

resource "vcd_vapp_vm" "workers_vms" {
  for_each = local.workersMachines
  vapp_name = local.vappName
  name = each.key
  catalog_name = local.catalogName
  template_name = local.templateName
  memory =  each.value["ram"]
  cpus = each.value["cpu"]
  cpu_cores = each.value["cpu"]

  network {
    type               = var.network_type
    name               = local.networkName
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }
  guest_properties = {
    "guestinfo.coreos.config.data.encoding" = "base64"
    "guestinfo.coreos.config.data" = base64encode(data.ct_config.worker_vm_ingition[each.key].rendered)
  }
  depends_on = [
    vcd_vapp_vm.masters_vms
  ]

}



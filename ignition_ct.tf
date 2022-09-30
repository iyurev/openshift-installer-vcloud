
locals {
  mastersAppendIgnUrl = "${var.nexus_proto}://${var.nexus_username}:${var.nexus_pass}@${local.nexusHostName}/repository/${local.nexusRepoName}/${local.clusterName }/master.ign"
  workersAppendIgnUrl = "${var.nexus_proto}://${var.nexus_username}:${var.nexus_pass}@${local.nexusHostName}/repository/${local.nexusRepoName}/${local.clusterName }/worker.ign"
  bootstrapIgnUrl = "${var.nexus_proto}://${var.nexus_username}:${var.nexus_pass}@${local.nexusHostName}/repository/${local.nexusRepoName}/${local.clusterName }/bootstrap.ign"
}

data "template_file" "bootstrap_vm_ingition_template" {
  for_each = local.bootStrapMachines
  template = file("${path.module}/ign.template.yaml")
  vars =  {
    ignUrl = local.bootstrapIgnUrl
    core_user_password_hash = local.coreUserPassword
    ssh_pub_key = local.sshPubKey
    hostname = each.key
    addr = each.value["ip_address"]
    mask = local.netmask
    gateway = local.gateway
    dns1 = local.dns1
    dns2  = local.dns2
    domain = local.domain
    cri_storage_label = var.cri_storage_label
    cri_storage_disk  = var.cri_storage_disk
    cri_storage_path = var.cri_storage_path
    cri_mount_systemd_unit_name = var.cri_mount_systemd_unit_name
  }
}
data "ct_config" "bootstrap_vm_ingition" {
  for_each = local.bootStrapMachines
  content      = data.template_file.bootstrap_vm_ingition_template[each.key].rendered
  pretty_print = true
}

data "template_file" "master_vm_ingition_template" {
  for_each = local.mastersMachines
  template = file("${path.module}/ign.template.yaml")
  vars =  {
    ignUrl = local.mastersAppendIgnUrl
    core_user_password_hash = local.coreUserPassword
    ssh_pub_key = local.sshPubKey
    hostname = each.key
    addr = each.value["ip_address"]
    mask = local.netmask
    gateway = local.gateway
    dns1 = local.dns1
    dns2  = local.dns2
    domain = local.domain
    cri_storage_label = var.cri_storage_label
    cri_storage_disk  = var.cri_storage_disk
    cri_storage_path = var.cri_storage_path
    cri_mount_systemd_unit_name = var.cri_mount_systemd_unit_name
  }
}
data "ct_config" "master_vm_ingition" {
  for_each = local.mastersMachines
  content      = data.template_file.master_vm_ingition_template[each.key].rendered
  pretty_print = true
}

data "template_file" "worker_vm_ingition_template" {
  for_each = local.workersMachines
  template = file("${path.module}/ign.template.yaml")
  vars =  {
    ignUrl = local.workersAppendIgnUrl
    core_user_password_hash = local.coreUserPassword
    ssh_pub_key = local.sshPubKey
    hostname = each.key
    addr = each.value["ip_address"]
    mask = local.netmask
    gateway = local.gateway
    dns1 = local.dns1
    dns2  = local.dns2
    domain = local.domain
    cri_storage_label = var.cri_storage_label
    cri_storage_disk  = var.cri_storage_disk
    cri_storage_path = var.cri_storage_path
    cri_mount_systemd_unit_name = var.cri_mount_systemd_unit_name
  }
}
data "ct_config" "worker_vm_ingition" {
  for_each = local.workersMachines
  content      = data.template_file.worker_vm_ingition_template[each.key].rendered
  pretty_print = true
}
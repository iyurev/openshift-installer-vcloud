data "local_file" "cluster-conf-raw" {
  filename = "${path.module}/clusters/openshift-stage.yaml"
}

locals {
  clusterConf = yamldecode("${data.local_file.cluster-conf-raw.content}")
  vcdUrl = local.clusterConf["vcd_url"]
  vcdUser = local.clusterConf["vcd_user"]
  vcdOrg  = local.clusterConf["vcd_org"]
  vcdVdcName = local.clusterConf["vcd_vdc_name"]
  catalogName = local.clusterConf["catalog_name"]
  vappName = local.clusterConf["vapp_name"]
  templateName = local.clusterConf["template_name"]
  domain = local.clusterConf["domain"]
  clusterName = local.clusterConf["cluster_name"]
  pullSecret = local.clusterConf["pull_secret"]
  sshPubKey = local.clusterConf["ssh_pub_key"]
  nexusHostName = local.clusterConf["nexus_hostname"]
  nexusRepoName = local.clusterConf["nexus_reponame"]
  coreUserPassword = local.clusterConf["core_user_password_hash"]
  networkName = local.clusterConf["network_name"]
  netmask = local.clusterConf["netmask"]
  gateway = local.clusterConf["gateway"]
  dns1 = local.clusterConf["dns1"]
  dns2 = local.clusterConf["dns2"]
  bootStrapMachines = local.clusterConf["bootstrap_machine"]
  mastersMachines = local.clusterConf["masters"]
  workersMachines = local.clusterConf["workers"]
}

resource "null_resource" "cluster-init" {
  provisioner "ansible" {

    plays {
      playbook {
        file_path = "./ansible/init_cluster_plb.yaml"
        roles_path = ["./ansible/roles"]
      }
      become = false
      diff = false
      extra_vars = {
        domain = local.domain
        cluster_name = local.clusterName
        pull_secret = local.pullSecret
        ssh_pub_key = local.sshPubKey
        nexus_repo_url = "${var.nexus_proto}://${local.nexusHostName}/repository/${local.nexusRepoName}"
      }
      forks = 1
      inventory_file = "./ansible/hosts.yaml"
      verbose = false
    }
  }
}








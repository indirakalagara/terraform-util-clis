
locals {
  bin_dir = var.bin_dir != "" ? var.bin_dir : "${path.cwd}/bin2"
}

data external setup-binaries {
  program = ["bash", "${path.module}/scripts/setup-binaries.sh"]

  query = {
    bin_dir = local.bin_dir
    clis = join(",", var.clis)
  }
}

resource null_resource setup-binaries {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-binaries.sh '${local.bin_dir}' '${join(",", var.clis)}'"
  }

}

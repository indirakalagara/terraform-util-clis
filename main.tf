
locals {
  bin_dir = var.bin_dir != "" ? var.bin_dir : "${path.cwd}/bin2"
}

resource null_resource print {
  provisioner "local-exec" {
    command = "echo 'Installing clis: ${join(",", var.clis)}'"
  }
}

data external setup-binaries {
  depends_on = [null_resource.print]

  program = ["bash", "${path.module}/scripts/setup-binaries.sh"]

  query = {
    bin_dir = local.bin_dir
    clis = join(",", var.clis)
  }
}

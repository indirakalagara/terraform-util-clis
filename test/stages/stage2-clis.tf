module "clis" {
  source = "./module"
}

resource null_resource write_path {
  provisioner "local-exec" {
    command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
  }
}

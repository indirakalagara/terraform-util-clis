module "clis" {
  source = "./module"

  clis = ["rclone"]
  
}

resource "null_resource" "write_path" {
  provisioner "local-exec" {
    #command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
    command = "echo ${module.clis.bin_dir} > .bin_dir"
  }
}

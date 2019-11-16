terraform {
  required_version = "~> 0.11"
}

data "template_file" "tf-fastly-redirects-error" {
  template = "${file("${path.module}/vcl/snippet/tf-fastly-redirects-error.vcl.tpl")}"

  vars = {
    error-code = "${var.error-code}"
  }
}

data "template_file" "tf-fastly-redirects-recv" {
  template = "${file("${path.module}/vcl/snippet/tf-fastly-redirects-recv.vcl.tpl")}"

  vars = {
    rendered-redirects = "${indent(2, join("\n", data.template_file.tf-path-fastly-redirect-partial.*.rendered))}"
  }
}

data "template_file" "tf-path-fastly-redirect-partial" {
  template = "${file("${path.module}/vcl/partial/tf-path-fastly-redirect-partial.vcl.tpl")}"
  count    = "${length(var.path-redirect-block)}"

  vars = {
    destination = "${element(values(var.path-redirect-block[count.index]), 0)}"
    source      = "${element(keys(var.path-redirect-block[count.index]), 0)}"
    error-code  = "${var.error-code}"
  }
}

variable "error-code" {
  type    = "string"
  default = "942"
}

variable "path-redirect-block" {
  type = "list"

  default = [
    {
      "/test/" = "https://example.com/"
    }
  ]
}


# Outputs
output "tf-fastly-redirects-recv" {
  value = "${data.template_file.tf-fastly-redirects-recv.rendered}"
  description = "Fastly snippet to catch paths must be redirected"
}

output "tf-fastly-redirects-error" {
  value = "${data.template_file.tf-fastly-redirects-error.rendered}"
  description = "Fastly snippet to serve redirects"
}
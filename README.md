# tf-fastly-redirects
A Terraform module for simplifying redirects across Fastly services.
Internally this generates VCL snippets for inclusion in a Fastly service, serving a 302 response code.

## Compatibility
Currently only supports Terraform v0.11.
Requires Fastly v0.8 or higher.

__For Terraform v0.12 check `redirects-v0.12` branch.__

## Path Format
Paths are case-insensitive, and are defined with a leading slash and without a trailing slash, i.e. `/an-example-link`.

## Usage

1. Define a new variable for storing redirects.
```terraform
variable "path-redirects" {
    default = [
        {"/this-is-a-test" = "https://www.example.com/"}
    ]
}
```

2. Import this module
```terraform
module "fastly-redirect" {
  source = "github.com/financial-times/terraform-module-fastly-redirect"

  # Error code, configurable to avoid clashing with other VCL.
  error-code = "917"

  # A list containing redirects.
  path-redirect-block = ["${var.path-redirects}"]
}
```

3. Add the following two snippets to your fastly service
```terraform
resource "fastly_service_v1" "fastly-redirects" {

  # Catch generated redirects.
  snippet {
    name = "tf-fastly-redirects-recv"
    type = "recv"
    content = "${module.fastly-redirects.tf-fastly-redirects-recv}"
  }

  # Serve generated redirects.
  snippet {
    name = "tf-fastly-redirects-error"
    type = "error"
    content = "${module.fastly-redirects.tf-fastly-redirects-error}"
  }
}
```

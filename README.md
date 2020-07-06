# tf-fastly-redirects
A Terraform module for simplifying redirects across Fastly services.
Internally this generates VCL snippets for inclusion in a Fastly service, serving a 302 response code.

This branch supports Terraform v0.12
Requires Fastly v0.12 or higher.

## Path Format
Paths are case-insensitive, and are defined with a leading slash and without a trailing slash, i.e. `/an-example-link`.

## Usage

1. Define a new variable for storing redirects.
```terraform
variable "path-redirects" {
    type    = list(map(string))
    default = [
        {"/this-is-a-test" = "https://www.example.com/"}
    ]
}
```

2. Import this module
```terraform
module "fastly-redirect" {
  source = "github.com/financial-times/tf-fastly-redirects?ref=redirects-v0.12"

  # Error code, configurable to avoid clashing with other VCL.
  error-code = "917"

  # A list containing redirects.
  path-redirect-block = var.path-redirects
}
```

3. Add the following two snippets to your fastly service
```terraform
resource "fastly_service_v1" "fastly-redirects" {

  # Catch generated redirects.
  snippet {
    name = "tf-fastly-redirects-recv"
    type = "recv"
    content = module.fastly-redirect.tf-fastly-redirects-recv
  }

  # Serve generated redirects.
  snippet {
    name = "tf-fastly-redirects-error"
    type = "error"
    content = module.fastly-redirect.tf-fastly-redirects-error
  }
}
```

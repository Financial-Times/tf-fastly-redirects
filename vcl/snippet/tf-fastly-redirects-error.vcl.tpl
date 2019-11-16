// Handle redirects thrown in tf-fastly-redirects-recv.vcl
if (obj.status == ${error-code}) {
  set obj.http.Location = obj.response;
  set obj.http.Server = "tf-fastly-redirects";
  set obj.status = 301;
  set obj.response = "Moved Permanently";
}
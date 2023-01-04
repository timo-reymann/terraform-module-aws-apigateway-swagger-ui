package tests

import (
	"crypto/tls"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func doHttpTestCall(t *testing.T, invoke_url string, status int, headers map[string]string) {
	http_helper.HTTPDoWithRetry(t, "GET", invoke_url, []byte{}, headers, status, 10, 10*time.Second, &tls.Config{})
}

func testSwaggerEndpoints(t *testing.T, terraformOptions *terraform.Options, prefix string) {
	invoke_url := terraform.Output(t, terraformOptions, "invoke_url")
	base_url := invoke_url + prefix + "/swagger-ui"
	doHttpTestCall(t, base_url, 200, map[string]string{})
	doHttpTestCall(t, base_url+"/swagger-ui.html", 200, map[string]string{})
	doHttpTestCall(t, base_url+"/swagger-ui.css", 200, map[string]string{})
}

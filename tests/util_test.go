package tests

import (
	"crypto/tls"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	testing "testing"
	"time"
)

func doHttpTestCall(t *testing.T, invoke_url string, status int, headers map[string]string) {
	http_helper.HTTPDoWithRetry(t, "GET", invoke_url, []byte{}, headers, status, 10, 10*time.Second, &tls.Config{})
}

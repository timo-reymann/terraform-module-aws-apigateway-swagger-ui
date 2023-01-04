package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)


func TestRoutesJSON(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "http-routes-json",
		Vars:         map[string]interface{}{},
	})

	defer terraform.Destroy(t, terraformOptions)

    terraform.Init(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
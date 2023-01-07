package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestRoutesJSON(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/http-routes-json",
		Vars:         map[string]interface{}{},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	testSwaggerEndpoints(t, terraformOptions, "")
}

func TestRoutesJSONUpdateIdempotent(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/http-routes-json",
		Vars:         map[string]interface{}{},
	})
	terraformOptionsUpdate := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "http-routes-json",
		Vars: map[string]interface{}{
			"openapi_file": "petstore.updated.json",
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	// apply with intial config
	terraform.InitAndApply(t, terraformOptions)

	// apply with new config, after first apply it shouldnt lead to a change
	terraform.ApplyAndIdempotent(t, terraformOptionsUpdate)

	// Swagger UI works also after openapi spec update
	testSwaggerEndpoints(t, terraformOptions, "")
}

func TestRoutesJSONWithStage(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/http-routes-json-with-stage",
		Vars:         map[string]interface{}{},
	})

	defer terraform.Destroy(t, terraformOptions)

	// apply with intial config
	terraform.InitAndApply(t, terraformOptions)

	// Swagger UI works also after openapi spec update
	testSwaggerEndpoints(t, terraformOptions, "/v1")
}

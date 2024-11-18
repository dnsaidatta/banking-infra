package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBackendService2Module(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/backend_service_2",
		Vars: map[string]interface{}{
			"project_prefix":           "test-project",
			"region":                   "West Europe",
			"resource_group_name":      "test-rg",
			"subnet_id":                "/subscriptions/test-public-subnet-id",
			"database_connection_string": "AccountEndpoint=https://public-cosmos-db.test.com;AccountKey=testKey;",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	appServiceURL := terraform.Output(t, terraformOptions, "app_service_url")
	assert.Contains(t, appServiceURL, "test-project-service2", "Backend Service 2 URL should match expected format")
}

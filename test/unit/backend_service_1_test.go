package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBackendService1Module(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/backend_service_1",
		Vars: map[string]interface{}{
			"project_prefix":           "test-project",
			"region":                   "West Europe",
			"resource_group_name":      "test-rg",
			"subnet_id":                "/subscriptions/test-subnet-id",
			"cosmos_db_private_ip":     "10.0.2.5",
			"database_connection_string": "AccountEndpoint=https://cosmos-db.test.com;AccountKey=testKey;",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	appServiceURL := terraform.Output(t, terraformOptions, "app_service_url")
	assert.Contains(t, appServiceURL, "test-project-service1", "Backend Service 1 URL should match expected format")
}

// test/unit/app_gateway_test.go

package unit

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAppGatewayModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/app_gateway",

		Vars: map[string]interface{}{
			"project_prefix":       "testbank",
			"region":               "West Europe",
			"resource_group_name":  "testbank-rg",
			"vnet_id":              "/subscriptions/mock-subscription/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet",
			"subnet_id":            "/subscriptions/mock-subscription/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/mock-subnet",
		},
		NoColor: true,
	}

	// Clean up resources after test execution
	defer terraform.Destroy(t, terraformOptions)

	// Apply Terraform and validate outputs
	terraform.InitAndApply(t, terraformOptions)

	// Validate that the public IP is not empty
	appGatewayIP := terraform.Output(t, terraformOptions, "public_ip")
	assert.NotEmpty(t, appGatewayIP, "Application Gateway Public IP should not be empty")

	// Additional validation checks can be added here
}

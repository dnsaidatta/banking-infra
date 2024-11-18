// test/unit/vnet_test.go

package unit

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVNetModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/vnet",

		Vars: map[string]interface{}{
			"project_prefix":       "testbank",
			"region":               "West Europe",
			"resource_group_name":  "testbank-rg",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vnetID := terraform.Output(t, terraformOptions, "vnet_id")
	assert.Contains(t, vnetID, "testbank-vnet")

	frontendSubnetID := terraform.Output(t, terraformOptions, "frontend_subnet_id")
	assert.NotEmpty(t, frontendSubnetID, "Frontend subnet ID should not be empty")
}

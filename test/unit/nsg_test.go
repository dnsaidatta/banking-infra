// test/unit/nsg_test.go

package unit

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNSGModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/nsg",

		Vars: map[string]interface{}{
			"project_prefix":       "testbank",
			"region":               "West Europe",
			"resource_group_name":  "testbank-rg",
			"allowed_ips":          []string{"203.0.113.0/24"},
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	internalNSGID := terraform.Output(t, terraformOptions, "internal_backend_nsg_id")
	assert.NotEmpty(t, internalNSGID, "Internal Backend NSG ID should not be empty")
}

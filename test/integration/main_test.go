// test/integration/main_test.go

package integration

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestIntegrationAzureBankingInfra(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../..",
    VarFiles: []string{"../testing.tfvars"}, // Use the testing.tfvars file
    NoColor:  true,
    }
    
		Vars: map[string]interface{}{
			"region":         "West Europe",
			"project_prefix": "testbank",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate Application Gateway IP
	appGatewayIP := terraform.Output(t, terraformOptions, "app_gateway_ip")
	assert.NotEmpty(t, appGatewayIP, "Application Gateway IP should not be empty")

	// Validate React Web App URL
	reactWebAppURL := terraform.Output(t, terraformOptions, "react_web_app_url")
	assert.Contains(t, reactWebAppURL, "web.core.windows.net", "React Web App URL should be valid")

	// Validate Backend Service #1 (Internal API)
	backendService1URL := terraform.Output(t, terraformOptions, "backend_service_1_url")
	assert.Empty(t, backendService1URL, "Backend Service #1 should not expose a public URL")

	// Validate Backend Service #2 (Public API)
	backendService2URL := terraform.Output(t, terraformOptions, "backend_service_2_url")
	assert.NotEmpty(t, backendService2URL, "Backend Service #2 URL should not be empty")
}

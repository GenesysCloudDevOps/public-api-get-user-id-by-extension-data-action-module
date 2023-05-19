resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "userExtension" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "id" = {
                "type" = "string"
            }
        },
        "title" = "results",
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\r\n  \"pageSize\": 1,\r\n  \"pageNumber\": 1,\r\n  \"types\": [\r\n    \"users\"\r\n  ],\r\n  \"sortOrder\": \"SCORE\",\r\n  \"query\": [\r\n    {\r\n      \"type\": \"EXACT\",\r\n      \"fields\": [\r\n        \"addresses\"\r\n      ],\r\n      \"operator\": \"AND\",\r\n      \"value\": \"$${input.userExtension}\"\r\n    }\r\n  ]\r\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/search?profile=false"
        headers = {
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\"id\": $${id}}"
        translation_map = { 
			id = "$.results[0].id"
		}
               
    }
}
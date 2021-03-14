# Azure Login
# az login

# Subscription selection
$subscription_id = "7c8e928e-4cb2-4a61-b009-b830c91f5ea7"
az account set --subscription $subscription_id


# Variable setting
    # Unique prefix / suffix (if you want to prepend or append some unique identifier to rerource names)
    $prefix = ""
    $suffix = ""
    $basic_name = "kmvi" # Name to be assigned to all resource created within this script

    # Resource Group
    $resource_group = 'KnowledgeMining-RG'
    
    # Azure Cognitive Search
    $cognitive_search = $basic_name + '-search-service'
    $cognitive_search_api_Version = "2019-05-06"
    $cognitive_search_index = $prefix + "conversational-index" + $suffix
  


# Azure Cognitive Search

        # Get Azure Cogntive Search Key
        $cognitive_search_key = az search admin-key show --resource-group $resource_group --service-name $cognitive_search -o tsv --query primaryKey

        # Azure Cognitive Search Request Header and Parameters
        $header = @{'Content-Type' = 'application/json'; 'api-key' = $cognitive_search_key}

        
            # Create Index
            # POST https://[servicename].search.windows.net/indexes?api-version=[api-version]  
            #   Content-Type: application/json   
            #   api-key: [admin key] 
            
            # Create index for insights
            $json_index = Get-Content 'video-knowledge-mining-index.json' 
            $cognitive_search_api_endpoint_index = "https://"+ $cognitive_search + ".search.windows.net/indexes/" + $cognitive_search_index + "?api-version=" + $cognitive_search_api_Version
            $response = Invoke-WebRequest -Uri $cognitive_search_api_endpoint_index -Method 'PUT' -Body $json_index -Headers $header

            # Create index for time references
            $cognitive_search_index = $cognitive_search_index + "-time-references"

            $json_index = Get-Content 'video-knowledge-mining-index-time-references.json' 
            $cognitive_search_api_endpoint_index = "https://"+ $cognitive_search + ".search.windows.net/indexes/" + $cognitive_search_index + "?api-version=" + $cognitive_search_api_Version
            $response = Invoke-WebRequest -Uri $cognitive_search_api_endpoint_index -Method 'PUT' -Body $json_index -Headers $header

package spacelift

# Block public Azure Storage static website hosting while allowing private storage accounts.

# Allow: resource group creation
allow[{"msg": msg}] {
    input.resource.resource_type == "azurerm_resource_group"
    input.resource.operation == "create"

    msg := sprintf(
        "Resource group creation allowed: %s",
        [input.resource.resource_id]
    )
}

# Allow: storage account creation (private accounts are fine)
allow[{"msg": msg}] {
    input.resource.resource_type == "azurerm_storage_account"
    input.resource.operation == "create"

    msg := sprintf(
        "Storage account creation allowed: %s",
        [input.resource.resource_id]
    )
}

# Allow: storage containers (if the account is private)
allow[{"msg": msg}] {
    input.resource.resource_type == "azurerm_storage_container"
    input.resource.operation == "create"

    msg := sprintf(
        "Storage container creation allowed: %s",
        [input.resource.resource_id]
    )
}

# Allow: blob uploads (if the account is private)
allow[{"msg": msg}] {
    input.resource.resource_type == "azurerm_storage_blob"
    input.resource.operation == "create"

    msg := sprintf(
        "Storage blob upload allowed: %s",
        [input.resource.resource_id]
    )
}

# Deny: enabling static website hosting (public hosting)
deny[{"msg": msg}] {
    input.resource.resource_type == "azurerm_storage_account_static_website"
    input.resource.operation == "create"

    msg := sprintf(
        "POLICY VIOLATION: Public Azure Storage static website hosting is not allowed. Attempted to enable static website hosting for storage account '%s'. Contact security team for exceptions.",
        [input.resource.proposed_state.storage_account_id]
    )
}

# Deny: storage account allowing public blob/container access
deny[{"msg": msg}] {
    input.resource.resource_type == "azurerm_storage_account"
    input.resource.operation == "create"

    proposed := input.resource.proposed_state
    proposed.allow_nested_items_to_be_public == true

    msg := sprintf(
        "POLICY VIOLATION: Public Azure Storage access is not allowed. Storage account '%s' has allow_nested_items_to_be_public set to true. All public access must be blocked.",
        [proposed.name]
    )
}

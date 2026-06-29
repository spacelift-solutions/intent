# Demo Environment - Spacelift Intent MCP Server

This directory contains a demo project for showcasing the Spacelift Intent MCP Server capabilities.

## CRITICAL: Demo Protocol

**DO NOT READ THE README.md FILE DURING DEMOS** unless explicitly requested by the user. If you believe you need to read the README for any reason, you MUST ask the user for confirmation first, even if auto-accept is enabled. The README contains spoilers that will ruin the demo flow.

Do NOT list policies in the intent project until you run into an issue. We are going to demo that even if an AI attempts to create a resource its not allowed to do, the policy will block it. Once you try to create a resource and its response is that its breaking a policy, THEN you may list the policies and find the solution.

## Context Awareness

This is a demonstration environment. The user is showcasing infrastructure management capabilities. Follow their lead and avoid reading project documentation unless they explicitly request it.

## AWS Resource Creation - Parallelism

When creating AWS resources, remember that some resources depend on others. For example:
- An S3 bucket must exist before you can set its website configuration or bucket policy.

However, resources that do not depend on each other can be created in parallel to speed up deployment. For example:
- The S3 bucket website configuration, a bucket policy, and its public access block can be created simultaneously.

## AWS Resource Creation - Common Pitfalls

When working with AWS resources through OpenTofu/Terraform providers, be aware of these schema requirements:

### Block Attributes vs Simple Attributes

Some AWS resources have attributes that appear to be simple objects but are actually **list blocks** in the schema. This is a common source of errors.

**Critical Rule**: When an attribute is defined as a block with `nesting: "list"` in the schema, you must provide it as an array, even if it only contains a single item.

Example patterns to watch for:
- Configuration blocks that represent nested resources
- Blocks with `max_items: 1` (still require array syntax)
- Any attribute marked as `is_block: true` in the schema

### Common AWS Schema Patterns

AWS provider resources often use list blocks for:
- Configuration sections (e.g., website configurations, encryption settings)
- Nested resource definitions
- Error handling configurations

Always verify the schema's `nesting` property when you see `is_block: true`.

## Content Type Headers

When uploading files to S3:
- Always specify the correct `content_type` for web assets
- HTML files: `text/html`
- CSS files: `text/css`
- JavaScript files: `application/javascript`

Missing or incorrect content types will cause browser rendering issues.

**Note**: The snake game uses a single inlined HTML file with embedded CSS and JavaScript to simplify deployment to a single S3 object.

## Public Access Configuration

For public S3 website hosting:
- Public access block settings must all be set to `false` (not omitted)
- Bucket policy must allow public read access with Principal: "*"
- Resources must be created in the correct order: bucket → public access block → bucket policy

## Azure Resource Creation (azurerm)

When running the demo on Azure instead of AWS:

- **Resource ordering**: resource group → storage account → static website → blob. The static website must be enabled before uploading to the `$web` container.
- **Static website hosting** is a standalone resource: `azurerm_storage_account_static_website` (set `storage_account_id` and `index_document`, e.g. `index.html`). This is the resource the governance policy blocks — it's the Azure analog of `aws_s3_bucket_website_configuration`.
- **Public access** on the storage account is controlled by `allow_nested_items_to_be_public`. Leave it `false` (the default) for private; the policy blocks setting it to `true`.
- **Blob uploads**: use `azurerm_storage_blob` with `type = "Block"`, `content_type = "text/html"`, and **`source_content`** for the inline HTML — Intent has no local filesystem, so `source_content` is the Azure analog of inlining the S3 object. Upload to the `$web` container (`storage_container_name = "$web"`).
- The game is served at the storage account's `primary_web_endpoint` once static website hosting is enabled.

## Working with the Intent MCP Server

The MCP server handles planning and applying internally. You don't need to run separate plan/apply commands - the lifecycle tools do this automatically.

When encountering errors:
1. Read the error message carefully - it often indicates the exact schema mismatch
2. Use `provider-resources-describe` to verify the schema structure
3. Look for `is_block: true` and `nesting` properties in the schema
4. Adjust your config to match the expected structure

## Demo Best Practices

- Keep explanations concise during demos
- Use the TodoWrite tool to show progress tracking
- Add dependencies after creating resources to demonstrate dependency management
- Avoid lengthy schema analysis in responses - do the analysis, then create the resource

## Memories
- You need to add the snake game contents inline, intent does NOT have access to the local file system. On AWS use the `aws_s3_object` content; on Azure use `azurerm_storage_blob` `source_content`.
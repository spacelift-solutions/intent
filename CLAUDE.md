# Demo Environment - Spacelift Intent MCP Server

This directory contains a demo project for showcasing the Spacelift Intent MCP Server capabilities.

## CRITICAL: Demo Protocol

**DO NOT READ THE README.md FILE DURING DEMOS** unless explicitly requested by the user. If you believe you need to read the README for any reason, you MUST ask the user for confirmation first, even if auto-accept is enabled. The README contains spoilers that will ruin the demo flow.

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
- You need to add the snake game contents inline with the aws_s3_object resource, intent does NOT have access to the local file system.
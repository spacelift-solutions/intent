# Spacelift Intent MCP Server Demo - Snake Game

This project demonstrates the capabilities of the Spacelift Intent MCP Server by deploying a fully functional browser-based Snake game to AWS S3 static website hosting - entirely through AI-driven infrastructure management.

## Project Overview

This snake game was **100% created using AI**, including:
- Game logic and implementation
- UI/UX design with Dracula theme color scheme
- AWS infrastructure setup and configuration
- Debugging and bug fixes based on user feedback
- All infrastructure deployed through the Spacelift Intent MCP Server

## What is Spacelift Intent?

Spacelift Intent is an MCP (Model Context Protocol) server that provides AI assistants with the ability to manage infrastructure through OpenTofu/Terraform. It handles:
- Resource lifecycle management (create, read, update, delete)
- Dependency tracking between resources
- Policy enforcement and validation
- State management
- Provider schema discovery

## Replicating This Demo

**Phase 1: Setup Intent Project**

1. Clone this repository to your local machine: `git clone git@github.com:spacelift-solutions/intent.git`
    - cd into its directory before continuing (if you dont do this, the mcp server wont work correctly with claude code)
2. Create a new Spacelift Intent Project in your Spacelift account (note its id for later)
3. Create the `block-public-s3-websites.rego` **intent** policy to your Spacelift account.
4. Attach the policy to your Intent Project.
5. Setup claude with your Spacelift Intent Server ex. `claude mcp add -t http spacelift https://spacelift-solutions.app.spacelift.io/intent/mcp`
6. Ensure the MCP server is authenticated by starting a new claude code session and running `/mcp`. 

**Phase 2: Start Demo and Demonstrate Blocking**

1. Start a new Claude Code session
2. Request: "Use Spacelift Intent project `{your-intent-project-id}`"
3. Request: "Let's deploy my snake game to Amazon S3"
4. Observe: The AI will successfully create the S3 bucket, but policy violations will block:
   - `aws_s3_bucket_website_configuration` - Public hosting blocked
   - `aws_s3_bucket_public_access_block` - Public access blocked (all 4 settings must be `true`)
   - `aws_s3_bucket_policy` - Public bucket policy blocked (Principal: "*" not allowed)
5. The deployment will fail with clear policy violation messages

**Phase 3: Remove Policy and Deploy Successfully**

1. Remove the policy from your Intent Project in Spacelift
2. Request: "I've removed the policy, lets try deploying it now."
3. Observe: All resources create successfully without policy blocking
4. The snake game is now publicly accessible

**Phase 4: Cleanup**

1. Request: "Delete all resources in my Intent project"
2. Confirm with: `CONFIRM`

### Key Demo Highlights

- **Policy-as-Code**: Rego policies provide governance and compliance guardrails
- **Clear Violations**: Policy messages explain exactly what's blocked and why
- **Selective Enforcement**: Policies allow private S3 buckets while blocking public ones
- **AI Understanding**: The AI interprets policy violations and explains them to users
- **Flexible Governance**: Policies can be attached/removed as needed per environment

**Important**: The README.md file contains implementation details that make for a less engaging demo. The CLAUDE.md file ensures the AI doesn't read this file unless explicitly requested.

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

## Infrastructure Components

The deployed application consists of:

1. **S3 Bucket** (`aws_s3_bucket`)
   - Name: `snake-game-demo-joey`
   - Region: `us-east-1`
   - Force destroy enabled for easy cleanup

2. **Website Configuration** (`aws_s3_bucket_website_configuration`)
   - Index document: `index.html`
   - Configured for static website hosting

3. **Public Access Configuration** (`aws_s3_bucket_public_access_block`)
   - All public access restrictions disabled
   - Allows public website hosting

4. **Bucket Policy** (`aws_s3_bucket_policy`)
   - Public read access for all objects
   - Allows browser access to game files

5. **Game File** (`aws_s3_object`)
   - `index.html` - Single self-contained HTML file with inlined CSS (Dracula-themed styling) and JavaScript (complete snake game logic)

## Replicating This Demo

### Basic Demo (No Policy Enforcement)

1. Start a new Claude Code session
2. The AI will read CLAUDE.md automatically (global instructions, just to avoid some minor pitfalls of AI)
3. Connect to the Spacelift Intent MCP server
4. Request: "Use Spacelift Intent Project `{your-project-id}`"
5. Request: "Let's deploy my snake game to Amazon S3"
6. Follow the natural conversation flow
7. The AI will avoid the pitfalls from the original development

### Advanced Demo (With Policy Enforcement)

This demonstrates Spacelift Intent's policy enforcement capabilities:

**Phase 1: Attach Policy and Demonstrate Blocking**

1. Start a new Claude Code session
2. Request: "Use Spacelift Intent Project `{your-project-id}`"
3. Request: "Create a policy from the file `block-public-s3-websites.rego` with the name 'Block Public S3 Websites' and description 'Prevents public S3 website hosting for security compliance'"
4. Request: "Let's deploy my snake game to Amazon S3"
5. Observe: The AI will successfully create the S3 bucket, but policy violations will block:
   - `aws_s3_bucket_website_configuration` - Public hosting blocked
   - `aws_s3_bucket_public_access_block` - Public access blocked (all 4 settings must be `true`)
   - `aws_s3_bucket_policy` - Public bucket policy blocked (Principal: "*" not allowed)
6. The deployment will fail with clear policy violation messages

**Phase 2: Remove Policy and Deploy Successfully**

7. Request: "List all policies"
8. Request: "Delete the policy '{policy-id}' we just created"
9. Request: "Now let's deploy the snake game to S3"
10. Observe: All resources create successfully without policy blocking
11. The snake game is now publicly accessible

**Phase 3: Cleanup**

12. Request: "Delete all resources in my Intent project"
13. Confirm with: `CONFIRM`

### Key Demo Highlights

- **Policy-as-Code**: Rego policies provide governance and compliance guardrails
- **Clear Violations**: Policy messages explain exactly what's blocked and why
- **Selective Enforcement**: Policies allow private S3 buckets while blocking public ones
- **AI Understanding**: The AI interprets policy violations and explains them to users
- **Flexible Governance**: Policies can be attached/removed as needed per environment

**Important**: The README.md file contains implementation details that make for a less engaging demo. The CLAUDE.md file ensures the AI doesn't read this file unless explicitly requested.

# 100 AI Prompts for Software Engineers (Claude, Gemini, Cursor)

Prompts tailored for Software Engineering workflows, modern dev stacks, and AI skill management (`ai-dev-skills`).

---

## 1. Claude Prompts (34 Prompts)
*Focus: Architectural reasoning, deep code review, long-form technical documentation, skill creation, complex refactoring.*

### Architecture & System Design
1. **System Architecture Review**: "Analyze this codebase architecture. Identify structural bottlenecks, tight coupling, and violation of SOLID principles. Suggest modular refactoring steps."
2. **ADR Generation**: "Draft an Architecture Decision Record (ADR) for switching from monolith to event-driven microservices. Include context, decision, consequences, and compliance risks."
3. **API Contract Design**: "Design a RESTful & GraphQL schema for an order management system. Ensure idempotent mutations, versioning strategy, and standardized error responses."
4. **Database Schema Optimization**: "Evaluate this PostgreSQL schema for high-throughput write load. Recommend indexing strategies, partitioning, and query optimization."
5. **Microservices Boundary Mapping**: "Review our domain models and map out bounded contexts based on Domain-Driven Design (DDD) principles."

### Code Quality & Deep Review
6. **Security Audit**: "Perform a SAST security review on this authentication module. Identify OWASP Top 10 vulnerabilities (XSS, SQLi, CSRF, IDOR) with concrete fixes."
7. **Thread Safety & Concurrency**: "Audit this concurrent worker pool implementation for race conditions, memory leaks, and deadlocks. Provide thread-safe alternatives."
8. **Design Pattern Refactoring**: "Identify code smells in this 1,000-line controller. Refactor it using Strategy and Factory design patterns without breaking signatures."
9. **Legacy Code Modernization**: "Modernize this legacy ES5/Callback codebase to modern TypeScript Async/Await with strict typing and Zod schema validation."
10. **Error Handling Architecture**: "Propose a centralized exception handling and custom error hierarchy for our Node.js microservices."

### Technical Writing & Documentation
11. **Comprehensive API Docs**: "Generate OpenAPI 3.0 specs and developer documentation with code examples in cURL, Python, and TypeScript for this endpoint."
12. **SDK / Library Readme**: "Write a production-ready `README.md` for this open-source library including quickstart, architecture diagram (Mermaid), config options, and troubleshooting."
13. **Migration Guide**: "Create a step-by-step breaking-change migration guide for users upgrading from v1.x to v2.0 of our framework."
14. **Post-Mortem Report**: "Structure a Blameless Post-Mortem artifact from these incident logs. Include root cause analysis (5 Whys), timeline, and actionable preventive measures."
15. **System RFC**: "Write an RFC for introducing a distributed caching layer (Redis) to lower DB query latency by 40%."

### Skill & Agent Engineering (ai-dev-skills)
16. **Skill Specification (SKILL.md)**: "Draft a production `SKILL.md` for `architecture-reviewer`. Define frontmatter (name, description), workflow steps, and execution guidelines."
17. **Agent System Prompt Construction**: "Construct a system prompt for an AI agent tasked with automated PR review. Enforce non-pedantic feedback and strict JSON output."
18. **Prompt Engineering Audit**: "Review this set of system prompts. Optimize them to reduce token usage by 30% while improving instruction-following precision."
19. **Caveman Style Adapter**: "Transform this verbose technical guideline document into ultra-concise caveman format instructions while preserving all rules."
20. **Multi-Agent Orchestration Design**: "Design a multi-agent workflow (Investigator -> Builder -> Reviewer) for handling complex bug triage automatically."

### Testing & Verification
21. **Edge Case Test Suite Generation**: "Generate comprehensive unit tests using Jest/PyTest covering all edge cases, boundary conditions, and null/undefined handling for this function."
22. **Integration Test Strategy**: "Design an integration testing setup using Testcontainers for isolated DB and Redis testing in CI."
23. **Property-Based Testing**: "Write property-based tests (using Fast-Check or Hypothesis) to verify invariant conditions for this financial calculation engine."
24. **E2E Scenario Drafting**: "Draft Playwright E2E test scripts covering the user checkout flow, handling flaky UI elements and network retries."

### DevOps, CI/CD & Security
25. **Kubernetes Deployment Manifest**: "Generate production-grade Kubernetes deployment manifests (Deployment, HPA, Secret, Ingress, PDB) for a high-availability Go service."
26. **GitHub Actions Pipeline**: "Create a zero-downtime CI/CD GitHub Actions workflow with linting, security scanning, parallel unit testing, matrix builds, and canary deployment."
27. **Terraform Infrastructure as Code**: "Write modular Terraform code for AWS ECS Fargate, ALB, and RDS Aurora with encryption at rest and transit."
28. **Dockerfile Security Hardening**: "Harden this Dockerfile: multi-stage build, non-root user, minimal base image (distroless), dependency caching, and vulnerability scanning."

### Complex Problem Solving & Debugging
29. **Root Cause Analysis from Log Dumps**: "Analyze these stack traces and distributed trace logs (Jaeger/Zipkin). Trace the cascading failure across microservices."
30. **Memory Leak Investigation**: "Given this heap dump analysis summary, pinpoint the object retention path causing the memory leak in Node.js/V8."
31. **Performance Tuning Benchmark**: "Write benchmark test routines (BenchmarkDotNet / Go testing.B) and recommend performance optimizations for this serialization routine."
32. **Algorithm Optimization**: "Optimize this nested loop matching algorithm from O(N^2) to O(N log N) or O(N) using appropriate data structures (HashMaps, Tries)."
33. **Distributed Locking Strategy**: "Explain potential failure modes in our Redis Redlock implementation and propose a fencing-token-based Redlock fix."
34. **Backward Compatibility Check**: "Evaluate this database schema migration script for backward compatibility with running app instances during rolling deployment."

---

## 2. Gemini Prompts (33 Prompts)
*Focus: Multimodal context analysis, massive codebase scanning, multi-language translation, cloud integration, fast prototyping.*

### Codebase Scanning & Search
35. **Repo-wide Pattern Extraction**: "Scan this entire repository and list all API endpoints, their HTTP methods, auth requirements, and controller file locations."
36. **Unused Code & Dependency Pruning**: "Identify dead code, unused npm package dependencies, and deprecated API calls across the workspace."
37. **Configuration Audit**: "Compare `.env.example`, environment variables across environments, and Helm values to detect missing or mismatched parameters."
38. **Impact Analysis for Refactoring**: "If I change the signature of `UserService.updateProfile`, identify every dependent module, test file, and frontend client affected."
39. **Dependency Vulnerability Fix**: "Analyze our `package-lock.json` or `go.sum` vulnerability scan report and generate updated version resolutions."

### Multimodal & Vision Prompts
40. **UI Design to Code (Figma/Screenshot)**: "Convert this UI design screenshot into modern HTML5 + Vanilla CSS layout with flexbox/grid and smooth hover transitions."
41. **Architecture Diagram Extraction**: "Extract the node relationships and data flow from this architecture diagram image and output a clean Mermaid.js diagram."
42. **Database ERD to SQL**: "Convert this Database ERD image into executable DDL scripts for PostgreSQL with primary keys, foreign keys, and indexes."
43. **Error Screenshot Troubleshooting**: "Analyze this screenshot of the dashboard console error and network panel. Identify the root cause of the CORS failure."
44. **Wireframe to React Component**: "Translate this hand-drawn UI wireframe into accessible React components with Tailwind utility classes."

### Multi-Language Translation & Integration
45. **Python to TypeScript Rewrite**: "Convert this Python data parsing script to idiomatic TypeScript with strict type annotations and Zod validation."
46. **Java/Spring to Go Migration**: "Translate this Spring Boot REST controller and repository layer to idiomatic Go using Gin framework and GORM."
47. **SQL to Query Builder (Knox/Prisma)**: "Convert this complex raw PostgreSQL analytical query (CTEs, Window functions) into Prisma Client or Knex.js code."
48. **Shell Script to Node.js CLI**: "Refactor this 300-line bash automation script into a structured Node.js CLI tool using `commander` and `execa`."
49. **GraphQL to REST Wrapper**: "Create a Node.js middleware layer that wraps an legacy REST API and exposes a unified GraphQL endpoint."

### Cloud, Data & Automation
50. **Google Cloud Run Deployment**: "Write a deployment script and configuration for deploying a containerized application to GCP Cloud Run with Secret Manager integration."
51. **BigQuery Analytical SQL**: "Write a BigQuery SQL query to compute daily active users (DAU), user retention cohorts, and conversion funnel drop-offs."
52. **Event-Driven Messaging Setup**: "Implement a GCP Pub/Sub publisher and pull-subscriber in TypeScript with exponential backoff retry and DLQ (Dead Letter Queue)."
53. **Serverless Function Handler**: "Create a stateless AWS Lambda / GCP Cloud Function handler for processing webhook payloads with HMAC signature verification."
54. **ELK Log Parsing Regex**: "Generate Logstash / Fluentbit grok patterns and regex parsers for this custom application log format."

### Rapid Prototyping & Utilities
55. **Mock Data Generator Script**: "Write a script using `@faker-js/faker` to generate 10,000 realistic JSON records for user profiles and order histories."
56. **CLI Tool Scaffold**: "Generate a complete CLI boilerplate with argument parsing, colorized logger, progress bar, and config loader."
57. **Web Scraping & Extraction**: "Write a Puppeteer/Playwright script to extract product pricing table data, handling pagination and rate limiting."
58. **Regex Generator & Explanation**: "Create a regular expression to validate global phone numbers in E.164 format and explain each token."
59. **CRON Schedule Expression**: "Generate CRON expressions and explain schedule timing for: 'Run at 2:30 AM every weekday except holidays'."

### Performance & Edge Operations
60. **Bundle Size Optimization**: "Analyze `webpack-bundle-analyzer` or Vite build logs. Recommend code-splitting, tree-shaking, and lazy loading strategies."
61. **CDN Caching Strategy**: "Configure Cache-Control headers and Cloudflare Page Rules for static assets, dynamic API responses, and SSR pages."
62. **Database Connection Pool Tuning**: "Provide optimal connection pool settings (max connections, idle timeout, max lifetime) for PG under serverless AWS Lambda execution."
63. **Redis Caching Strategy**: "Design a Cache-Aside and Write-Through caching layer for user session state with TTL jitter to prevent cache stampede."
64. **Web Vitals Tuning**: "Suggest concrete code fixes to improve Largest Contentful Paint (LCP) and Cumulative Layout Shift (CLS) on the landing page."
65. **gRPC Protocol Buffer Definition**: "Define a `.proto` file for a high-throughput microservice streaming telemetry data in real-time."
66. **Fast API Mock Server**: "Create a lightweight Express/MSW mock server setup for frontend team development during backend API construction."
67. **Automated Release Notes Generator**: "Scan git commit messages between `v1.2.0` and `v1.3.0` and summarize changes into Markdown release notes grouped by Feature, Fix, and Breaking."

---

## 3. Cursor Prompts (33 Prompts)
*Focus: Inline coding, `.cursorrules` / `.mdc` rules, fast context-aware edits, diff reviews, instant bug fixing in IDE.*

### Rule File Creation (.cursorrules / .mdc)
68. **Always-On Caveman Rule (.mdc)**: "Write a `.cursor/rules/caveman.mdc` rule with `alwaysApply: true` enforcing terse, token-efficient technical responses."
69. **Project Coding Style Enforcer**: "Create a Cursor `.mdc` rule enforcing functional TypeScript patterns, banning `any`, and mandating named exports."
70. **Test Co-location Rule**: "Draft a Cursor rule mandating that every new file in `src/` must have a corresponding test file created in `tests/`."
71. **Commit Message Format Rule**: "Write a Cursor rule enforcing Conventional Commits standard (feat, fix, docs, refactor) with max 50 char subject."
72. **Security Constraint Rule**: "Create a Cursor rule warning immediately if plain-text credentials, API keys, or hardcoded URLs are added to code."

### Inline Code Generation & Completion
73. **Function Implementation from Signature**: "Implement this TS function signature: `async function syncUserStore(userId: string): Promise<Result<User, SyncError>>`."
74. **Type Definition & Interface Generation**: "Generate complete TypeScript interfaces and types for this raw JSON API response object."
75. **Component Prop Type Annotations**: "Add strict React prop types and default props to this un-typed JSX component."
76. **Boilerplate CRUD Endpoints**: "Generate Express.js router CRUD handlers for the `Product` entity with validation and error catching."
77. **Zod Validation Schema**: "Create a Zod schema matching this user registration form object, including custom password strength validation."

### Refactoring & In-place Editing
78. **Extract Sub-Component**: "Refactor this 400-line React component by extracting inline JSX items into smaller, reusable sub-components."
79. **Async/Await Conversion**: "Convert all Promises `.then().catch()` chains in selected lines to modern `try/catch async/await` blocks."
80. **Eliminate Code Duplication**: "Extract shared helper logic between these two functions into a shared utility file in `src/utils`."
81. **Inject Dependency Injection (DI)**: "Refactor this class constructor to accept dependencies via interface injection instead of instantiating directly."
82. **Rename & Propagate Symbol**: "Rename method `calculateTotal` to `computeOrderGrandTotal` across all files in workspace."

### Inline Debugging & Error Resolution
83. **Fix TypeScript Compiler Error**: "Fix TS error in this file: `Type 'null' is not assignable to type 'User'`. Update type guards."
84. **Fix Lint & Formatting Violations**: "Resolve all ESLint/Prettier warnings in current selection without changing runtime behavior."
85. **Resolve Import Path Conflicts**: "Fix broken relative imports in this file and replace them with configured `@/` alias paths."
86. **Null Pointer Prevention**: "Add optional chaining (`?.`) and nullish coalescing (`??`) safety checks to prevent `Cannot read property of undefined`."
87. **Fix Async Race Condition**: "Fix race condition in this `useEffect` hook by introducing an `AbortController` cleanup function."

### IDE Workflow & Chat Automation
88. **Diff Review & Explanation**: "Review the Git diff of current uncommitted changes. Summarize changes and check for accidental debug statements (`console.log`)."
89. **Terminal Command Troubleshooting**: "Command `npm run build` failed with exit code 1. Analyze terminal log output and suggest exact shell command to fix it."
90. **Git Merge Conflict Resolution**: "Help me resolve merge conflict markers (`<<<<<<< HEAD`, `=======`, `>>>>>>>`) in this configuration file."
91. **Unit Test Stubs Generation**: "Generate unit test stubs for all exported functions in current active file using Jest test suite format."
92. **Add JSDoc Annotations**: "Add JSDoc documentation comments for all public functions in this file, including `@param` and `@returns` tags."

### Skill Manifest & Tool Integration
93. **Register New Skill in Manifest**: "Add entry for `prompt-engineering-expert` to `skills.manifest.json` with source, scope, purpose, and invoke command."
94. **Installer Script Debugging**: "Fix `install.sh` shell script error when running `npx skills add` on non-interactive CI terminal environments."
95. **On-Demand Skill Invoker**: "Generate an on-demand invocation trigger prompt for `caveman-commit` skill to summarize git stage into commit message."
96. **Skill Conflict Audit**: "Scan `.cursor/rules/` directory for overlapping or conflicting rule instructions between installed skills."
97. **Cursor Rules Clean Up**: "Prune unused or outdated `.mdc` rule files under `.cursor/rules` and ensure file permissions are correct."
98. **Environment Variable Injection**: "Refactor inline `process.env` references to use a centralized strongly-typed `env.ts` config module."
99. **Mock Service Worker Setup**: "Generate MSW request handlers to intercept `/api/v1/checkout` requests during Cursor inline testing."
100. **Quick Contextual Summary**: "Summarize purpose of active file, its inputs, outputs, and list top 3 maintenance risks."

---
name: model-router
description: >
  Dynamic Model Router skill for task allocation across LLMs. Evaluates task type, context size,
  reasoning complexity, latency, and cost to recommend or route to the optimal model (e.g., Gemini Flash/Pro,
  Claude Sonnet/Haiku, GPT-4o/o3-mini). Trigger: "model router", "select model", "route task", "which model to use".
---

# Model Router Skill

Guide for selecting and routing tasks to the optimal LLM model based on empirical requirements.

## Workflow & Execution Protocol

1. **Analyze Task**: Evaluate context size, logic complexity, cost sensitivity, and speed requirements.
2. **Recommend & Pause**: Present top model options with rationale. Ask user to confirm/select model before execution.
3. **Execute Task**: Proceed with implementation only after user selection.

## Task Classification Matrix

| Task Type | Key Requirements | Recommended Model Tier | Primary Model Examples |
|---|---|---|---|
| **Simple / Bulk Text / Formatting** | Fast, cheap, basic syntax | **Tier 1 (Fast & Light)** | Gemini 2.0 Flash, Claude 3.5 Haiku, GPT-4o-mini |
| **Standard Coding & Architecture** | High code intelligence, refactoring, agentic loop | **Tier 2 (Balanced / Standard)** | Claude 3.5 Sonnet, Gemini 1.5 Pro, GPT-4o |
| **Complex Reasoning & Math** | Multi-step logic, hard algorithmic problems, complex debug | **Tier 3 (Deep Reasoning)** | OpenAI o3-mini, o1, Gemini 2.0 Flash Thinking |
| **Massive Context (>200k tokens)** | Large codebase ingest, long video/audio/doc analysis | **Tier 4 (Ultra Long Context)** | Gemini 1.5 Pro (2M context), Gemini 2.0 Flash (1M context) |
| **Real-time / Interactive UI** | Lowest TTFT (time to first token), micro-tasks | **Tier 0 (Ultra Fast)** | Gemini 2.0 Flash Lite, Groq Llama 3.3 |

## Decision Tree Routing Logic

```
Task Received
 ├── Context > 200k tokens? ── YES ──> Gemini 1.5 Pro / 2.0 Flash
 ├── Math / Hard Logic / Algorithm design? ── YES ──> o3-mini / o1
 ├── Complex UI / Full Refactor / Agentic Workflow? ── YES ──> Claude 3.5 Sonnet / Gemini 1.5 Pro
 └── Simple Edit / Text Formatting / Routine Unit Tests? ── YES ──> Gemini 2.0 Flash / Haiku
```

## Routing Heuristics

1. **Token Cost Optimization**: Default to Tier 1 / Flash models for preliminary search & file discovery; switch to Tier 2 / Sonnet for critical code generation.
2. **Context Window Safety**: If prompt context approaches >100k tokens, prefer models with active context compaction or 1M+ token windows (Gemini Series).
3. **Reasoning Escalation**: If Tier 1 model fails test/build twice, automatically escalate task to Tier 2 or Tier 3 reasoning models.

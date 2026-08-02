---
name: runtime-forensics
description: >
  Live runtime instrumentation & systematic debugging playbook. Diagnoses memory leaks, CPU spikes,
  hanging processes, unhandled rejections, race conditions, and unexpected execution behavior using
  empirical state analysis and targeted instrumentation.
  Use when asked to debug runtime issues, investigate performance degradation, analyze process behavior,
  or invoke /runtime-forensics.
---

Perform systematic runtime forensics and live execution analysis to isolate root causes without guessing.

## Diagnostic Core Principles
- **Diagnosis First, Fix Second:** Goal is empirical proof of root cause before modifying business logic.
- **Empirical Log & State Evidence:** Never form hypotheses without inspecting active stack traces, heap dumps, CPU profiles, or execution logs.
- **No Masking:** Never wrap failing calls in empty try-catch blocks, dummy fallbacks, or swallow runtime exceptions.

## Forensics Workflow

### 1. Symptom & Environment Capture 🔴
- **Process Identification:** Inspect running process ID (PID), memory usage (RSS, Heap Used), CPU load.
- **Log Inspection:** Read recent un-truncated error logs, stdout/stderr streams, crash tracebacks.
- **Environment & State:** Check environment variables (`.env`), feature flags, active thread pools, network connectivity, DB connection pool health.

### 2. Hypothesis Matrix & Binary Search 🟡
- Formulate candidate root causes based on observed behavior:
  - **Memory Leak:** Retained event listeners, growing cache maps, unclosed sockets/streams.
  - **CPU Spin / Event Loop Blocking:** Synchronous loops, un-indexed query processing, heavy regex backtracking.
  - **Deadlock / Hang:** Unhandled Promise lock wait, blocking synchronization on main event loop.
  - **State Corruption / Race Condition:** Concurrent mutations without atomic locks or immutability.
- Binary-search problem space by eliminating unaffected modules through targeted state checks.

### 3. Live Instrumentation & Probing 🔵
- **Targeted Logging:** Add high-signal micro-logs (timestamp, thread/async context, input payload, execution duration).
- **Runtime Probing:** Capture heap snapshots, inspect process memory flamegraphs, record call durations.
- **Assertions & Guards:** Insert transient invariants to trigger explicit stack trace capture at moment of failure.

### 4. Root Cause Synthesis & Report 🟢
- Isolate exact line of code, parameter condition, or sequence of events causing the failure.
- Document step-by-step reproduction and empirical proof.
- Propose minimal, non-breaking remediation.

# Configuration placement

Choose the narrowest owner that covers every task needing the behavior.

| Content | Owner |
|---|---|
| Safe behavior used across environments | Public portable configuration |
| Harness or integration behavior | That harness package |
| Private work behavior and non-public systems | Private work overlay |
| Stable behavior repeatedly applicable across future tasks in one repository | That repository |
| Credentials, sessions, caches, generated files, and model state | Untracked local storage |

Keep public material harness-neutral and refer to private overlays generically. Keep adapters with their harness and private implementation details with the private overlay.

Repository guidance belongs there when it is stable across future tasks and experience demonstrates repeated friction, costly rediscovery, or meaningful risk. Keep task state and temporary workarounds with the task. Promote guidance only after repeated use demonstrates a broader scope.

Installers should manage only their owned files and preserve neighboring runtime state.

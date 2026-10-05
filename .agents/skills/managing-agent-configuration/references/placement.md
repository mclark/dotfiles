# Configuration placement

Choose the narrowest owner that covers every task needing the behavior.

| Content | Owner |
|---|---|
| Safe behavior used across environments | Public portable configuration |
| Harness or integration behavior | That harness package |
| Private work behavior and non-public systems | Private work overlay |
| Repository-specific behavior | That repository |
| Credentials, sessions, caches, generated files, and model state | Untracked local storage |

Keep public material harness-neutral and refer to private overlays generically. Keep adapters with their harness and private implementation details with the private overlay.

Keep repository guidance local until repeated use demonstrates a cross-repository need. Installers should manage only their owned files and preserve neighboring runtime state.

# CLI Command Structure and Syntax
`dsn~cli.command-syntax~1`

Defines the complete command tree, subcommands, arguments, and options for the CLI binary `app`.

Covers: req~cli.command-structure~1

Needs: impl, utest, uman, dman

---

## Command Hierarchy

<!-- Subcommands and options are nested via Markdown headings only. -->
<!-- dsn NEVER covers another dsn; the graph remains flat while Markdown provides structural readability. -->

### Command: `app auth`
Root group for authentication and token management commands.

#### Subcommand: `app auth login`
Authenticates the user against the configured identity provider and stores credentials locally.

- **Options**:
  - `--endpoint <URL>`: Identity provider base URL.
  - `--token <SECRET>`: Static API token for non-interactive logins.

#### Subcommand: `app auth logout`
Purges cached credentials and invalidates active session tokens.

- **Options**:
  - `-y`, `--yes`: Skip confirmation prompt.

---

### Command: `app config`
Root group for viewing and setting application configuration values.

#### Subcommand: `app config get <KEY>`
Reads and displays the effective value of a configuration key.

#### Subcommand: `app config set <KEY> <VALUE>`
Persists an updated configuration setting into the local configuration file.

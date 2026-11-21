# Type-Driven Development (TDD) in Rust

Rust's powerful type system allows making invalid states unrepresentable at compile time. This guide outlines best practices for type-driven design in production Rust applications.

---

## 1. Domain-Specific Identifier Wrappers (Newtype Pattern)

Never use primitive types like `u64`, `String`, or bare `Uuid` directly for entity identifiers. Mixing up IDs (e.g. passing an `AccountId` to a function expecting an `OrderId`) is a frequent source of bugs.

### Recommended Pattern

Use the Newtype pattern with `derive_more` and `uuid`:

```rust
use derive_more::{Display, From, Into};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Display, From, Into)]
pub struct UserId(Uuid);

impl UserId {
    pub fn new() -> Self {
        Self(Uuid::new_v4())
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Display, From, Into)]
pub struct OrderId(Uuid);

impl OrderId {
    pub fn new() -> Self {
        Self(Uuid::new_v4())
    }
}

// Compile error if you accidentally swap IDs:
pub fn assign_order_to_user(order: OrderId, user: UserId) {
    // ...
}
```

---

## 2. Statically Constrained Types

Choose types that encode business rules and validation constraints statically:

| Domain Concept | Avoid | Use Instead |
| :--- | :--- | :--- |
| **IP Addresses** | `String` | `std::net::IpAddr` (`IpAddr::V4`, `IpAddr::V6`) |
| **Web URLs** | `String` | `url::Url` |
| **File Paths** | `String` | `std::path::PathBuf` / `&std::path::Path` |
| **Non-Zero Counts** | `u32`, `usize` | `std::num::NonZeroU32`, `std::num::NonZeroUsize` |
| **Non-Empty Text** | `String` | `non_empty_string::NonEmptyString` |
| **Port Numbers** | `u32`, `i32` | `u16` |
| **Sensitive Secrets** | `String` | `secrecy::SecretString` |

---

## 3. Strict Secrets Management with `secrecy`

Never store API keys, passwords, database credentials, or auth tokens in standard `String` or `Vec<u8>`. Bare strings can leak into logs, stack traces, core dumps, or debug representations.

### Safe Secrets Handling

```rust
use secrecy::{ExposeSecret, SecretString};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct ApiCredentials {
    pub client_id: String,
    pub api_secret: SecretString,
}

impl ApiCredentials {
    pub fn authenticate(&self) {
        // Debug printing credentials will output "[REDACTED]"
        log::debug!("Authenticating with secret: {:?}", self.api_secret);

        // Access the raw secret ONLY at the exact point of consumption:
        let raw_token: &str = self.api_secret.expose_secret();
        send_auth_header(raw_token);
    }
}
```

---

## 4. Error Hierarchy with `thiserror` (Avoid `anyhow`)

Production code should provide structured, enumerable, and matchable error types using `thiserror`.

- **Avoid `anyhow` in libraries and application core**: `anyhow` erases error types into dynamic trait objects, making it impossible for callers to programmatically handle specific errors.
- **Hierarchical Error Design**: Each subsystem defines its own error enum. The parent or crate root wraps them cleanly:

```rust
//! Subsystem error hierarchy.

#[derive(Debug, thiserror::Error)]
pub enum DatabaseError {
    #[error("Record not found for key: {0}")]
    NotFound(String),

    #[error("Database connection failed: {0}")]
    ConnectionFailed(#[source] std::io::Error),
}

#[derive(Debug, thiserror::Error)]
pub enum AuthError {
    #[error("Invalid credentials provided")]
    InvalidCredentials,

    #[error("Token expired at timestamp {0}")]
    TokenExpired(u64),
}

/// Root crate error wrapping subsystem errors.
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    #[error("Database error: {0}")]
    Database(#[from] DatabaseError),

    #[error("Authentication error: {0}")]
    Auth(#[from] AuthError),

    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
}

/// Standardized Result alias for the crate.
pub type Result<T> = std::result::Result<T, AppError>;
```

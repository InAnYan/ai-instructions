# Type-Driven Development (TDD) in Rust

Rust's powerful type system allows making invalid states unrepresentable at compile time. This guide outlines best practices for type-driven design and modular separation in production Rust applications.

---

## 1. Domain-Specific Identifier Wrappers (Newtype Pattern)

Never use primitive types like `u64`, `String`, or bare `Uuid` directly for entity identifiers. Mixing up IDs (e.g. passing an `AccountId` to a function expecting an `OrderId`) is a frequent source of bugs.

Each domain entity and its ID live in their own dedicated module file:

### File: `src/models/user.rs`

```rust
//! User domain model and type-safe identifier.

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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: UserId,
    pub name: String,
}
```

### File: `src/models/order.rs`

```rust
//! Order domain model and type-safe identifier.

use derive_more::{Display, From, Into};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::models::user::UserId;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Display, From, Into)]
pub struct OrderId(Uuid);

impl OrderId {
    pub fn new() -> Self {
        Self(Uuid::new_v4())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Order {
    pub id: OrderId,
    pub customer_id: UserId, // Compile-time check prevents passing OrderId here!
    pub total_cents: u64,
}
```

### File: `src/models/mod.rs`

```rust
//! Models module re-exporting domain entities.

pub mod order;
pub mod user;

pub use order::{Order, OrderId};
pub use user::{User, UserId};
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

### File: `src/auth/credentials.rs`

```rust
//! Secure authentication credentials handling.

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

fn send_auth_header(_token: &str) {
    // Transport implementation
}
```

---

## 4. Error Hierarchy with `thiserror` (Avoid `anyhow`)

Production code should provide structured, enumerable, and matchable error types using `thiserror`.

- **Avoid `anyhow` in libraries and application core**: `anyhow` erases error types into dynamic trait objects, making it impossible for callers to programmatically handle specific errors.
- **Hierarchical Error Design**: Each subsystem defines its own error enum in its own file. The root crate error wraps them cleanly.

### File: `src/database/error.rs`

```rust
//! Database subsystem errors.

#[derive(Debug, thiserror::Error)]
pub enum DatabaseError {
    #[error("Record not found for key: {0}")]
    NotFound(String),

    #[error("Database connection failed: {0}")]
    ConnectionFailed(#[source] std::io::Error),
}
```

### File: `src/auth/error.rs`

```rust
//! Authentication subsystem errors.

#[derive(Debug, thiserror::Error)]
pub enum AuthError {
    #[error("Invalid credentials provided")]
    InvalidCredentials,

    #[error("Token expired at timestamp {0}")]
    TokenExpired(u64),
}
```

### File: `src/error.rs` (Crate Root Error)

```rust
//! Root crate error hierarchy.

use crate::auth::error::AuthError;
use crate::database::error::DatabaseError;

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

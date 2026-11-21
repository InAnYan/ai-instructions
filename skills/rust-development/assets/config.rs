//! Layered application configuration with modular component separation.
//!
//! Sub-configurations live in their own dedicated module files:
//! - `src/config/server.rs`
//! - `src/config/logging.rs`
//! - `src/config/security.rs`
//! - `src/config/mod.rs` (Root loader composing sub-configurations)

// ============================================================================
// File: src/config/server.rs
// ============================================================================
pub mod server {
    use std::net::IpAddr;
    use serde::Deserialize;

    #[derive(Debug, Deserialize, Clone)]
    pub struct ServerConfig {
        pub host: IpAddr,
        pub port: u16,
    }
}

// ============================================================================
// File: src/config/logging.rs
// ============================================================================
pub mod logging {
    use serde::Deserialize;

    #[derive(Debug, Deserialize, Clone)]
    pub struct LoggingConfig {
        pub level: String,
    }
}

// ============================================================================
// File: src/config/security.rs
// ============================================================================
pub mod security {
    use secrecy::SecretString;
    use serde::Deserialize;

    #[derive(Debug, Deserialize, Clone)]
    pub struct SecurityConfig {
        /// Sensitive credentials protected by secrecy crate.
        pub api_token: SecretString,
    }
}

// ============================================================================
// File: src/config/mod.rs
// ============================================================================
use std::path::Path;
use config::{Config, ConfigError, Environment, File};
use serde::Deserialize;

pub use logging::LoggingConfig;
pub use security::SecurityConfig;
pub use server::ServerConfig;

/// Root application configuration composing component modules.
#[derive(Debug, Deserialize, Clone)]
pub struct AppConfig {
    pub server: ServerConfig,
    pub logging: LoggingConfig,
    pub security: SecurityConfig,
}

impl AppConfig {
    /// Loads configuration with layering and environment variable precedence.
    pub fn load(config_path: Option<&Path>, env_prefix: &str) -> Result<Self, ConfigError> {
        let mut builder = Config::builder();

        // 1. Layer file configuration if present
        if let Some(path) = config_path {
            builder = builder.add_source(File::from(path).required(true));
        } else if Path::new("config/default.yaml").exists() {
            builder = builder.add_source(File::with_name("config/default.yaml").required(false));
        }

        // 2. Layer environment variables (takes strict precedence over file settings)
        builder = builder.add_source(
            Environment::with_prefix(env_prefix)
                .separator("__")
                .try_parsing(true),
        );

        builder.build()?.try_deserialize()
    }
}

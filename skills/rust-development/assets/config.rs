//! Layered application configuration.
//!
//! Loads configuration in layers:
//! 1. Base YAML configuration file (`config/default.yaml` or custom path).
//! 2. Environment variables with a designated prefix (e.g., `APP_*`).
//!
//! Environment variables take strict precedence over file settings.

use std::path::Path;
use config::{Config, ConfigError, Environment, File};
use secrecy::SecretString;
use serde::Deserialize;

/// Root application configuration.
#[derive(Debug, Deserialize, Clone)]
pub struct AppConfig {
    pub server: ServerConfig,
    pub logging: LoggingConfig,
    pub security: SecurityConfig,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ServerConfig {
    pub host: std::net::IpAddr,
    pub port: u16,
}

#[derive(Debug, Deserialize, Clone)]
pub struct LoggingConfig {
    pub level: String,
}

#[derive(Debug, Deserialize, Clone)]
pub struct SecurityConfig {
    /// Sensitive secret loaded securely.
    pub api_token: SecretString,
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

        // 2. Layer environment variables (takes precedence over file settings)
        builder = builder.add_source(
            Environment::with_prefix(env_prefix)
                .separator("__")
                .try_parsing(true),
        );

        builder.build()?.try_deserialize()
    }
}

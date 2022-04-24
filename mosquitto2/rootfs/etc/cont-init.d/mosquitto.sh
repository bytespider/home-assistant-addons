#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Configures mosquitto
# ==============================================================================
readonly SECURITY="/etc/mosquitto/dynamic-security.json"
readonly SYSTEM_USER="/data/system_user.json"
declare admin_password
declare cafile
declare certfile
declare discovery_password
declare keyfile
declare service_password
declare ssl

# Read or create system account data
if ! bashio::fs.file_exists "${SYSTEM_USER}"; then
  admin_password="$(pwgen 64 1)"
  discovery_password="$(pwgen 64 1)"
  service_password="$(pwgen 64 1)"

  # Store it for future use
  bashio::var.json \
    admin "^$(bashio::var.json password "${admin_password}")" \
    homeassistant "^$(bashio::var.json password "${discovery_password}")" \
    addons "^$(bashio::var.json password "${service_password}")" \
    > "${SYSTEM_USER}"
else
  # Read the existing values
  admin_password=$(bashio::jq "${SYSTEM_USER}" ".admin.password")
  discovery_password=$(bashio::jq "${SYSTEM_USER}" ".homeassistant.password")
  service_password=$(bashio::jq "${SYSTEM_USER}" ".addons.password")
fi

# Initialise dynamic-security and setup admin user
mosquitto_ctrl dynsec init "${SECURITY}" admin "${admin_password}"

keyfile="/ssl/$(bashio::config 'keyfile')"
certfile="/ssl/$(bashio::config 'certfile')"
cafile="/ssl/$(bashio::config 'cafile')"
if bashio::fs.file_exists "${certfile}" \
  && bashio::fs.file_exists "${keyfile}";
then
  bashio::log.info "Certificates found: SSL is available"
  ssl="true"
  if ! bashio::fs.file_exists "${cafile}"; then
    cafile="${certfile}"
  fi
else
  bashio::log.info "SSL is not enabled"
  ssl="false"
fi

# Generate mosquitto configuration.
bashio::var.json \
  cafile "${cafile}" \
  certfile "${certfile}" \
  customize "^$(bashio::config 'customize.active')" \
  customize_folder "$(bashio::config 'customize.folder')" \
  keyfile "${keyfile}" \
  require_certificate "^$(bashio::config 'require_certificate')" \
  ssl "^${ssl}" \
  | tempio \
    -template /usr/share/tempio/mosquitto.gtpl \
    -out /etc/mosquitto/mosquitto.conf
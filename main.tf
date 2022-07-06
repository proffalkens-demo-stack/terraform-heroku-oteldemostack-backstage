resource "heroku_app" "backstage" {
  name   = var.backstage_app_name
  region = var.backstage_region
}

resource "heroku_addon" "backstage_pgsql" {
  app_id = heroku_app.backstage.id
  plan   = "heroku-postgresql:hobby-basic"
}

resource "heroku_config" "backstage_config" {
  vars = {
    GITHUB_AUTH_CLIENT_ID   = var.github_client_id
    GRAFANA_PROMETHEUS_URI  = var.prometheus_uri
    GRAFANA_PROMETHEUS_USER = var.prometheus_user
    GRAFANA_URI             = var.grafana_uri
  }

  sensitive_vars = {
    GITHUB_AUTH_CLIENT_SECRET = var.github_client_secret
    GITHUB_TOKEN              = var.github_pat
    GRAFANA_PROMETHEUS_TOKEN  = var.prometheus_token
    GRAFANA_TOKEN             = var.grafana_token
  }
}

resource "heroku_app_config_association" "backstage" {
  app_id = heroku_app.backstage.id

  vars           = heroku_config.backstage_config.vars
  sensitive_vars = heroku_config.backstage_config.sensitive_vars
}
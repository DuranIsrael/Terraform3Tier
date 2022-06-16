# --- root/backend ---

terraform {
  cloud {
    organization = "LUIT-DI-Terraform"

    workspaces {
      name = "di-project"
    }
  }
}
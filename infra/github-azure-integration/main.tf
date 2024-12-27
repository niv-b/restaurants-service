data "azurerm_subscription" "sub" {

}

module "identity-resource-group" {
  source   = "../modules/resource-group"
  name     = var.identity_rg_name
  location = var.location
  tags     = var.tags
}

module "gh_usi" {
  source   = "../modules/user-assigned-identity"
  name     = "${var.gh_uai_name}-${var.environment}"
  location = var.location
  rg_name  = module.identity-resource-group.name
  tags     = var.tags
}

module "gh_federated_credential" {
  source                             = "../modules/federated-identity-credential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-${var.environment}"
  rg_name                            = module.identity-resource-group.name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:environment:${var.environment}"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}

module "gh_federated_credential-pr" {
  source                             = "../modules/federated-identity-credential"
  federated_identity_credential_name = "${var.github_organization_target}-${var.github_repository}-pr"
  rg_name                            = module.identity-resource-group.name
  user_assigned_identity_id          = module.gh_usi.user_assinged_identity_id
  subject                            = "repo:${var.github_organization_target}/${var.github_repository}:pull_request"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}

module "contributor_role_assignment" {
  source       = "../modules/role-assignment"
  principal_id = module.gh_usi.user_assinged_identity_principal_id
  role_name    = "Contributor"
  scope_id     = data.azurerm_subscription.sub.id
}
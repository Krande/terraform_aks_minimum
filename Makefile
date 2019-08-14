include terraform.tfvars

init:
	terraform init \
	-backend-config="storage_account_name=$(az_storage_name)" \
	-backend-config="container_name=$(prefix)-state" \
	-backend-config="access_key=$(az_storage_access_key)" \
	-backend-config="key=$(az_backend_key)"

sync:
	az aks get-credentials --resource-group "$(prefix)-rg" --name "$(prefix)-k8s" --overwrite-existing --file .kubeconfig
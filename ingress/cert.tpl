apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-${cert_type}
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: ${email}
    server: ${cert_server}
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-${cert_type}
    # Enable the HTTP01 challenge mechanism for this Issuer
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx

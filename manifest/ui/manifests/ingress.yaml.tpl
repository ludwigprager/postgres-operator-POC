#apiVersion: "networking.k8s.io/v1"
#kind: "Ingress"
#metadata:
#  name: "postgres-operator-ui"
#  namespace: "default"
#  labels:
#    application: "postgres-operator-ui"
#spec:
#  # ingressClassName: "ingress-nginx"
#  rules:
#    - host: ${DNS_DOMAIN}
#      http:
#        paths:
#
#          - path: /
#            pathType: Prefix
#            backend:
#              service:
#                name: "postgres-operator-ui"
#                port:
#                  number: 80

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: postgres-operator-ui
  namespace: default
  labels:
    application: postgres-operator-ui
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$2

spec:
# ingressClassName: nginx
  rules:
    - host: ${DNS_DOMAIN}
      http:
        paths:

          - path: /postgres-operator-ui(/|$)(.*)
            pathType: Prefix
            backend:
              service:
                name: postgres-operator-ui
                port:
                  number: 80


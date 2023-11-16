###apiVersion: "networking.k8s.io/v1"
###kind: "Ingress"
###metadata:
###  name: "postgres-operator-ui"
###  namespace: "default"
###  labels:
###    application: "postgres-operator-ui"
###spec:
###  # ingressClassName: "ingress-nginx"
###  rules:
###    - host: ${DNS_DOMAIN}
###      http:
###        paths:
###
###          - path: /
###            pathType: Prefix
###            backend:
###              service:
###                name: "postgres-operator-ui"
###                port:
###                  number: 80
##
##apiVersion: networking.k8s.io/v1
##kind: Ingress
##metadata:
##  name: postgres-operator-ui
##  namespace: default
##  labels:
##    application: postgres-operator-ui
##  annotations:
##    nginx.ingress.kubernetes.io/use-regex: "true"
##    nginx.ingress.kubernetes.io/rewrite-target: /$2
##
##spec:
### ingressClassName: nginx
##  rules:
##    - host: ${DNS_DOMAIN}
##      http:
##        paths:
##
##          - path: /postgres-operator-ui(/|$)(.*)
##            pathType: Prefix
##            backend:
##              service:
##                name: postgres-operator-ui
##                port:
##                  number: 80
##
#
#
#apiVersion: networking.k8s.io/v1
#kind: Ingress
#metadata:
#  name: "postgres-operator-ui"
#  annotations:
#    ingress.kubernetes.io/ssl-redirect: "false"
#spec:
#  rules:
#  - http:
#      paths:
#
#      - path: /
#        pathType: Prefix
#        backend:
#          service:
#            name: postgres-operator-ui
#            port:
#              number: 80
#


#apiVersion: traefik.containo.us/v1alpha1
#kind: Middleware
#metadata:
#  name: strip-prefix
#  namespace: example # Namespace defined
#spec:
#  stripPrefixRegex:
#    regex:
#    - ^/[^/]+
#---
#kind: Ingress
#metadata:
#  annotations:
#    traefik.ingress.kubernetes.io/router.middlewares: example-strip-prefix@kubernetescrd




apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: postgres-operator-ui
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:

#     - path: /postgres-operator-ui
      - path: /
        pathType: Prefix
        backend:
          service:
            name: postgres-operator-ui
            port:
              number: 80

      - path: /postgres-operator-ui
        pathType: Prefix
        backend:
          service:
            name: postgres-operator-ui
            port:
              number: 80


-include config.mk

K8S_CONFIG_DIR = k8s/

K8S_CONFIG_SECRETS = ${K8S_CONFIG_DIR}secrets/prod.secrets

K8S_CONFIG_SECRET_TOKEN = ${K8S_CONFIG_DIR}secrets/prod.token

K8S_CONFIG_VOLUMES = ${K8S_CONFIG_DIR}volumes/

K8S_CONFIG_DEPLOYMENTS = ${K8S_CONFIG_DIR}deployments/

K8S_CONFIG_CONFIG = ${K8S_CONFIG_DIR}configs/production.env

.PHONY : deployment volumes databasesecret tokensecret config stop all update start

.DEFAULT : all

SHELL = /bin/sh

KUBECTL = kubectl

KUBECTLFLAGS = --context=${K8S_CONTEXT_NAME}

deployment :
	${KUBECTL} ${KUBECTLFLAGS} apply -f ${K8S_CONFIG_DEPLOYMENTS}

volumes :
	${KUBECTL} ${KUBECTLFLAGS} apply -f ${K8S_CONFIG_VOLUMES}

databasesecret :
	${KUBECTL} ${KUBECTLFLAGS} create secret generic databasecredentials --from-env-file=${K8S_CONFIG_SECRETS} --dry-run -o yaml | ${KUBECTL} ${KUBECTLFLAGS} apply -f -

tokensecret :
	${KUBECTL} ${KUBECTLFLAGS} create secret generic bottoken --from-file=prod.token=${K8S_CONFIG_SECRET_TOKEN} --dry-run -o yaml 	| ${KUBECTL} ${KUBECTLFLAGS} apply -f -

config :
	${KUBECTL} ${KUBECTLFLAGS} create configmap production-config --from-env-file=${K8S_CONFIG_CONFIG} --dry-run -o yaml | ${KUBECTL} ${KUBECTLFLAGS} apply -f -

stop :
	${KUBECTL} ${KUBECTLFLAGS} delete -f ${K8S_CONFIG_DEPLOYMENTS}

all : config tokensecret databasesecret volumes deployment

update : all

start : deployment

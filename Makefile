.PHONY: help delete check logs jumpbox

help :
	@echo "Usage:"
	@echo "   make delete           - delete the k3d cluster"
	@echo "   make check            - check the node app endpoints"
	@echo "   make logs             - check the node app logs"
	@echo "   make jumpbox          - deploy a 'jumpbox' pod"

delete :
	# delete the cluster (if exists)
	@# this will fail harmlessly if the cluster does not exist
	@dapr uninstall
	@k3d cluster delete

check :
	# curl all of the endpoints
	http localhost:30080/order

jumpbox :
	@# start a jumpbox pod
	@-kubectl delete pod jumpbox --ignore-not-found=true

	@kubectl run jumpbox --image=alpine --restart=Always -- /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"
	@kubectl wait pod jumpbox --for condition=ready --timeout=30s
	@kubectl exec jumpbox -- /bin/sh -c "apk update && apk add bash curl py-pip" > /dev/null
	@kubectl exec jumpbox -- /bin/sh -c "pip3 install --upgrade pip setuptools httpie" > /dev/null
	@kubectl exec jumpbox -- /bin/sh -c "echo \"alias ls='ls --color=auto'\" >> /root/.profile && echo \"alias ll='ls -lF'\" >> /root/.profile && echo \"alias la='ls -alF'\" >> /root/.profile && echo 'cd /root' >> /root/.profile" > /dev/null

	#
	# use kje <command>
	# kje http ngsa-memory:8080/version
	# kje bash -l

logs :
	kubectl logs --selector=app=node -c node

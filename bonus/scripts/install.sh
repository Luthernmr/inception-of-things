curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
    --set global.ingress.configureCertmanager=false \
    --set global.hosts.https="false" \
  -n gitlab

kubectl patch svc gitlab-webservice-default -n gitlab -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 -d;

kubectl apply -n argocd -f ../confs/application-will-app-bonus.yaml
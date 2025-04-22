docker build -t nginx-with-metrics .
minikube image load custom-nginx
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# Добавляем репозиторий prometheus-community
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Устанавливаем kube-prometheus-stack в namespace monitoring
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring


kubectl apply -f namespace.yaml
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-exporter-deployment.yaml
kubectl apply -f nginx-exporter-service.yaml
kubectl apply -f nginx-service-monitor.yaml

kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get servicemonitor -n monitoring

# Проверяем метрики экспортера (должны быть доступны)
kubectl port-forward svc/nginx-exporter 9113:9113 -n monitoring &
curl http://localhost:9113/metrics

# Открываем Prometheus UI
kubectl port-forward svc/prometheus-operator-kube-p-prometheus 9090:9090 -n monitoring &
# Открываем в браузере http://localhost:9090

# Проверяем, что метрики nginx есть в Prometheus
# В Prometheus UI выполните запрос: nginx_connections_active

kubectl port-forward svc/prometheus-operator-kube-p-prometheus 9090:9090 -n monitoring
kubectl port-forward svc/prometheus-operator-grafana 3000:80 -n monitoring

# Получить пароль Grafana
kubectl get secret prometheus-operator-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Проброс порта Grafana
kubectl port-forward svc/prometheus-operator-grafana 3000:80 -n monitoring
# Открыть http://localhost:3000, логин admin, пароль из команды выше
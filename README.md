# Большое ДЗ (helm, istio)

muffin-wallet и muffin-currency должны разворачиваться через helmfile

## Установка Istio
1. Установить Istio в кластер.
```
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.28.1
export PATH=$PWD/bin:$PATH
```
2. Включить автоматическую инжекцию sidecar-прокси для пространства имён, где развёрнуты микросервисы.
```
kubectl label namespace default istio-injection=enabled
```

## Конфигурация Istio
### Ingress Gateway:
1. Настритоь Istio Ingress Gateway для внешнего доступа к muffin-wallet.
2. Обеспечить маршрутизацию трафика по хосту (например, wallet.example.com).

### Observability:
1. Установить Kiali, Prometheus для визуализации трафика и метрик.
2. Настроить сбор метрик и трассировку запросов между микросервисами.

### Security:
1. Включить mTLS для шифрования трафика между микросервисами.
2. Настроить AuthorizationPolicy для ограничения доступа к muffin-currency только с muffin-wallet.

### Resilience:
1. Настроить Circuit Breaker и Retry для устойчивости к сбоям.
2. Реализовать таймауты и лимиты на количество запросов.

### VirtualService, ServiceEntry, Gateway :
1. Создать VirtualService для маршрутизации трафика между muffin-wallet и muffin-currency.
2. Взаимодействие с внешней БД через ServiceEntry


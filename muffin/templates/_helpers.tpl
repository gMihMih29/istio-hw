{{/* wallet */}}


{{- define "homework.wallet.name" -}}
{{- default .Chart.Name .Values.wallet.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "homework.wallet.fullname" -}}
{{- if .Values.wallet.fullnameOverride }}
{{- .Values.wallet.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.wallet.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Chart name */}}
{{- define "homework.wallet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Liveness probe */}}
{{- define "homework.wallet.livenessProbe" -}}
livenessProbe:
  httpGet:
    path: {{ .Values.wallet.Container.LivenessProbe.Path }}
    port: {{ .Values.wallet.Container.Port }}
  initialDelaySeconds: {{ .Values.wallet.Container.LivenessProbe.InitialDelaySeconds }}
  periodSeconds: {{ .Values.wallet.Container.LivenessProbe.PeriodSeconds }}
{{- end }}

{{/* Readiness probe */}}
{{- define "homework.wallet.readinessProbe" -}}
readinessProbe:
  httpGet:
    path: {{ .Values.wallet.Container.ReadinessProbe.Path }}
    port: {{ .Values.wallet.Container.Port }}
  initialDelaySeconds: {{ .Values.wallet.Container.ReadinessProbe.InitialDelaySeconds }}
  periodSeconds: {{ .Values.wallet.Container.ReadinessProbe.PeriodSeconds }}
{{- end }}

{{/* Selector labels */}}
{{- define "homework.wallet.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homework.wallet.name" . }}
{{- end }}


{{/* Common labels */}}
{{- define "homework.wallet.labels" -}}
helm.sh/chart: {{ include "homework.wallet.chart" . }}
{{ include "homework.wallet.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "homework.wallet.config" -}}
---
server:
  port: {{ .Values.wallet.Container.Port }}

spring:
  datasource:
    url: jdbc:postgresql://{{ .Values.postgres.host }}:{{ .Values.postgres.outsidePort }}/{{ .Values.postgres.db }}
    username: {{ .Values.postgres.user }}

currency:
  service:
    url: http://{{ include "homework.currency.fullname" . }}:{{ .Values.currency.OutsidePort }}/rate?from=PLAIN&to=CHOKOLATE

management:
  endpoints:
    web:
      exposure:
      include: health, info
  endpoint:
    health:
      probes:
      enabled: true
      show-details: always
{{- end }}


{{/* currency */}}


{{- define "homework.currency.name" -}}
{{- default .Chart.Name .Values.currency.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "homework.currency.fullname" -}}
{{- if .Values.currency.fullnameOverride }}
{{- .Values.currency.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.currency.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Chart name */}}
{{- define "homework.currency.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* Common labels */}}
{{- define "homework.currency.labels" -}}
helm.sh/chart: {{ include "homework.currency.chart" . }}
{{ include "homework.currency.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/* Selector labels */}}
{{- define "homework.currency.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homework.currency.name" . }}
{{- end }}

{{/* Liveness probe */}}
{{- define "homework.currency.livenessProbe" -}}
livenessProbe:
  httpGet:
    path: {{ .Values.currency.Container.LivenessProbe.Path }}
    port: {{ .Values.currency.Container.Port }}
  initialDelaySeconds: {{ .Values.currency.Container.LivenessProbe.InitialDelaySeconds }}
  periodSeconds: {{ .Values.currency.Container.LivenessProbe.PeriodSeconds }}
{{- end }}

{{/* Readiness probe */}}
{{- define "homework.currency.readinessProbe" -}}
readinessProbe:
  httpGet:
    path: {{ .Values.currency.Container.ReadinessProbe.Path }}
    port: {{ .Values.currency.Container.Port }}
  initialDelaySeconds: {{ .Values.currency.Container.ReadinessProbe.InitialDelaySeconds }}
  periodSeconds: {{ .Values.currency.Container.ReadinessProbe.PeriodSeconds }}
{{- end }}

{{- define "homework.wallet.logs.config" -}}
events {
}

http {
    server {
        listen {{ .Values.wallet.logs.Port }};
        location /logs {
            alias /usr/share/nginx/html;
            autoindex on;
        }
    }
}
{{- end }}
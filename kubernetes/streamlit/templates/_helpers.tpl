{{/*
Expand the name of the chart.
*/}}
{{- define "streamlit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "streamlit.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "streamlit.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "streamlit.labels" -}}
helm.sh/chart: {{ include "streamlit.chart" . }}
{{ include "streamlit.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "streamlit.selectorLabels" -}}
app.kubernetes.io/name: {{ include "streamlit.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "streamlit.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "streamlit.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Example
{{ include "dockerconfigjson" ( dict "user" .Values.user "token" .Values.token ) }}
*/}}
{{- define "dockerconfigjson" -}}
{{- $b64Token := printf "%s:%s" .user .token | b64enc -}}
{{- $dockerConfigJson := printf "{ \"auths\": { \"https://ghcr.io\": { \"auth\": \"%s\" } } }" $b64Token | b64enc -}}
{{- $dockerConfigJson -}}
{{- end -}}



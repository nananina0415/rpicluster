#!/bin/bash

# --- 스크립트 실행 권한 확인 ---
if [ "$EUID" -ne 0 ]; then
  echo "🚨 경고: 이 스크립트는 root 사용자로 실행해야 합니다."
  exit 1
fi

# 스크립트가 위치한 디렉토리로 이동 (경로 문제 방지)
cd "$(dirname "$0")" || exit

echo "✅ 클러스터 관리 계정 및 인프라 설정을 시작합니다."
echo "------------------------------------"

# --- 1단계: 필수 패키지 설치 ---
echo "⚙️  필수 패키지(git, python, ansible, docker)를 설치합니다..."
apk update
apk add --no-cache git python3 py3-pip openssh-client ansible docker openrc

# Docker 서비스 활성화 및 시작
rc-update add docker boot
service docker start
echo "✔  필수 패키지 설치 및 Docker 서비스 시작 완료."
echo ""

# --- 2단계: Ansible 플레이북 실행 ---
CONFIG_FILE="./cluster_config.yml"
echo "⚙️  'setup.yml' 플레이북을 실행하여 계정 및 권한을 설정합니다."

# Ansible이 이 스크립트를 통해 실행되므로, 터미널에 진행 상황이 모두 표시됩니다.
ansible-playbook setup.yml

# 플레이북 실행 성공 여부 확인
if [ $? -ne 0 ]; then
  echo "❌ Ansible 플레이북 실행 중 오류가 발생했습니다. 로그를 확인해주세요."
  exit 1
fi

echo "✔  Ansible 플레이북 실행 완료."
echo ""

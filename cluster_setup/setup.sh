#!/bin/bash

# 스크립트 실행 권한 확인
if [ "$EUID" -ne 0 ]; then
  echo "🚨 경고: 이 스크립트는 root 사용자로 실행해야 합니다."
  exit 1
fi

# 스크립트가 위치한 디렉토리로 이동하여 경로 문제를 방지합니다.
cd "$(dirname "$0")" || exit

echo "클러스터 전체 설정을 시작합니다."
echo "------------------------------------"

# 1단계: Ansible 실행을 위한 최소 패키지 설치
echo "Ansible 실행에 필요한 패키지(python3, ansible)를 설치합니다..."
apk update
apk add --no-cache python3 openssh-client ansible

echo "✔  필수 패키지 설치 완료."
echo ""

# 2단계: Ansible 플레이북 실행
echo "'setup.yml' 플레이북을 실행하여 전체 클러스터를 구성합니다."
ansible-playbook setup.yml # 인벤토리 파일(-i) 없이 바로 플레이북을 실행

# 플레이북 실행 성공 여부 확인
if [ $? -ne 0 ]; then
  echo "❌ Ansible 플레이북 실행 중 오류가 발생했습니다. 로그를 확인해주세요."
  exit 1
fi
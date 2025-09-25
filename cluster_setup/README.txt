cluster_config.yml  유저가 변경할 파일
setup.sh            유저가 실행할 파일
나머지는 디테일한 설정을 사용할 때 수정

- cluster_setup             배포될 폴더. 알파인리눅스 아무데나놓고 사용하면됨
  - cluster_config.yml      유저가 설정할 단 하나의 설정파일
  - setup.sh                유저가 실행할 단 하나의 실행파일
  - setup.yml               셋업쉘스크립트가사용할 최상위 플레이북
  - hosts.ini               cluster_config.yml내의 정보를 파싱해서 생성됨
  - roles
    -cluster_managers.yml   클러스터 매니저 계정/그룹설정
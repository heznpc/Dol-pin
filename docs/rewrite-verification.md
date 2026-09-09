# Rewrite verification

## 2026-09-09 — 착수

- 사용자 승인 조건 네 가지를 `rewrite-plan.md`에 명시.
- 기존 working tree clean 확인; remote visibility/운영 배포는 미확인.
- 코드 감사에서 RPC/행 잠금/기간 제약/환불 재조회 존재 확인.
- 기존 테스트 통과나 과거 문서의 구동 주장은 이번 검증으로 승계하지 않음.
- Docker default/orbstack socket이 없어 local Supabase 실행 불가.
- `~/.colima`가 `/Volumes/DevStore/VMs/Colima`를 가리키지만 DevStore가 현재
  mount되어 있지 않음. 기존 VM 디렉터리·symlink는 변경하지 않음.
- RN/Web 앱, migration reset, 실제 RLS, PG, E2E: 아직 미검증.

검증 실패를 지나쳐 다음 domain의 Web 구현으로 진행하지 않는다.

## 외장 SSD runtime 복구

- 사용자 지시: 내부 공간 부족, 외장 SSD에 새 runtime 설치.
- 외장 APFS SSD의 여유 약 309 GiB, 내부 약 7.3 GiB 확인.
- Colima 0.10.3 전용 `dol-pin` profile, CPU 4 / RAM 4 GiB / data disk 40 GiB.
- VM·다운로드 cache·임시 파일을 외장 volume으로 지정.
- 끊어진 기존 Colima symlink는 별도 backup으로 보존하고 외장 경로에 연결.
- VZ VM 실행 및 Docker 29.5.2 응답 확인. 전역 Docker context는 바꾸지 않음.
- `scripts/with-runtime.sh`로 명시적 runtime 경로와 Docker socket 사용.
- Supabase 이미지는 이 외장 VM으로 다운로드 중. migration reset은 아직 미검증.

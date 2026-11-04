# 01. 터미널 조작 · 권한 실습 로그

- 환경: Windows (PowerShell 5.1) → WSL2 Ubuntu, bash
- 작업 위치: `~/codyssey-workstation/practice` (Linux 홈 영역. `/mnt/c` 는 NTFS라 chmod가 반영되지 않으므로 사용하지 않음)
- 기록 방식: `set -x`로 실행 명령을 출력과 함께 기록. 셸 프롬프트 훅이 출력한 내부 추적 줄(`++`로 시작)은 가독성과 기기 식별값 노출 방지를 위해 제거함
- 참고: `set -x`는 리다이렉션(`>`)을 표시하지 않으므로 `echo` 줄의 `> note.txt`는 실제 입력 명령대로 보완 표기함

## 1. 터미널 기본 조작

| 요구 동작 | 사용 명령 |
|---|---|
| 현재 위치 확인 | `pwd` |
| 목록 확인(숨김 포함) | `ls -la` |
| 이동 | `cd` |
| 생성 | `mkdir -p`, `touch` |
| 복사 | `cp` |
| 이동/이름변경 | `mv` |
| 삭제 | `rm`, `rmdir` |
| 파일 내용 확인 | `cat` |
| 빈 파일 생성 | `touch` |

```bash
$ pwd
/home/seunga
$ mkdir -p /home/seunga/codyssey-workstation/practice
$ cd /home/seunga/codyssey-workstation/practice
$ pwd
/home/seunga/codyssey-workstation/practice
$ touch empty.txt
$ echo 'hello codyssey' > note.txt
$ ls -la
total 12
drwxr-xr-x 2 seunga seunga 4096 Nov  4 16:28 .
drwxr-xr-x 3 seunga seunga 4096 Nov  4 16:28 ..
-rw-r--r-- 1 seunga seunga    0 Nov  4 16:28 empty.txt
-rw-r--r-- 1 seunga seunga   15 Nov  4 16:28 note.txt
$ cat note.txt
hello codyssey
$ cp note.txt note_copy.txt
$ mv note_copy.txt renamed.txt
$ mkdir backup
$ mv renamed.txt backup/
$ ls -la backup
total 12
drwxr-xr-x 2 seunga seunga 4096 Nov  4 16:28 .
drwxr-xr-x 3 seunga seunga 4096 Nov  4 16:28 ..
-rw-r--r-- 1 seunga seunga   15 Nov  4 16:28 renamed.txt
$ rm backup/renamed.txt
$ rmdir backup
$ ls -la
total 12
drwxr-xr-x 2 seunga seunga 4096 Nov  4 16:28 .
drwxr-xr-x 3 seunga seunga 4096 Nov  4 16:28 ..
-rw-r--r-- 1 seunga seunga    0 Nov  4 16:28 empty.txt
-rw-r--r-- 1 seunga seunga   15 Nov  4 16:28 note.txt
$ cd /home/seunga/codyssey-workstation
$ pwd
/home/seunga/codyssey-workstation
$ cd practice
$ pwd
/home/seunga/codyssey-workstation/practice
```

### 절대 경로 vs 상대 경로
- 절대 경로: `cd /home/seunga/codyssey-workstation` — 루트(`/`)부터 시작하므로 현재 위치와 무관하게 같은 곳으로 이동
- 상대 경로: `cd practice` — 현재 위치(`/home/seunga/codyssey-workstation`)를 기준으로 해석됨. 다른 위치에서 실행하면 실패

## 2. 권한 변경 실습

```bash
$ mkdir perm-dir
$ touch perm-file.sh
$ ls -l perm-file.sh
-rw-r--r-- 1 seunga seunga 0 Nov  4 16:28 perm-file.sh
$ ls -ld perm-dir
drwxr-xr-x 2 seunga seunga 4096 Nov  4 16:28 perm-dir
$ chmod 755 perm-file.sh
$ chmod 700 perm-dir
$ ls -l perm-file.sh
-rwxr-xr-x 1 seunga seunga 0 Nov  4 16:28 perm-file.sh
$ ls -ld perm-dir
drwx------ 2 seunga seunga 4096 Nov  4 16:28 perm-dir
```

### 변경 전/후 비교

| 대상 | 변경 전 | 변경 후 | 의미 |
|---|---|---|---|
| 파일 `perm-file.sh` | `-rw-r--r--` (644) | `-rwxr-xr-x` (755) | 소유자·그룹·기타 모두 실행(x) 권한 추가 |
| 디렉토리 `perm-dir` | `drwxr-xr-x` (755) | `drwx------` (700) | 소유자 외 모든 접근 차단 |

### 권한 숫자 해석 규칙
- 세 자리 = 소유자(owner) / 그룹(group) / 기타(others)
- 각 자리 = r(읽기)4 + w(쓰기)2 + x(실행)1 의 합
- 644 = `rw-` `r--` `r--` → 소유자만 수정, 나머지는 읽기만 (일반 파일 기본값)
- 755 = `rwx` `r-x` `r-x` → 소유자만 수정, 모두 실행 가능 (스크립트·디렉토리 기본값)
- 디렉토리의 x 는 "그 폴더 안으로 들어갈(cd) 수 있는 권한"을 뜻함

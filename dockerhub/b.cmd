@echo off & setlocal enabledelayedexpansion
REM ===================================================================
REM Multi-Architecture Image Batch Build Script
REM ===================================================================

REM --- 설정 ---
SET DOCKER_ID=nananina0415
SET PREFIX=rpicluster
SET PLATFORMS=linux/amd64,linux/arm64

REM ✅ 빌드할 서비스 목록을 여기에 직접 나열합니다.
SET SERVICES_LIST=runner running_mate service storage task_queue

REM --- 빌드 시작 ---
echo.
echo Starting multi-arch build for all services...
echo Docker ID: %DOCKER_ID%
echo Image Prefix: %PREFIX%
echo Platforms: %PLATFORMS%
echo ===================================================================
echo.

REM 서비스 목록에 있는 각 서비스에 대해 반복
FOR %%s IN (%SERVICES_LIST%) DO (
    SET "SERVICE_NAME=%%s"
    SET "DOCKERFILE_NAME=!SERVICE_NAME!.df"

    echo.
    echo -------------------------------------------------------------------
    echo Building service: !SERVICE_NAME! using !DOCKERFILE_NAME!
    echo -------------------------------------------------------------------
    
    REM 해당 Dockerfile이 존재하는지 확인
    if not exist "!DOCKERFILE_NAME!" (
        echo ERROR: Dockerfile '!DOCKERFILE_NAME!' not found. Skipping.
    ) else (
        REM buildx 명령어 실행
        docker buildx build ^
            --platform %PLATFORMS% ^
            -f !DOCKERFILE_NAME! ^
            -t %DOCKER_ID%/%PREFIX%-!SERVICE_NAME!:latest ^
            --push ^
            .
        
        REM 빌드 실패 시 스크립트 중단
        if %errorlevel% neq 0 (
            echo.
            echo ERROR: Build failed for service !SERVICE_NAME!.
            exit /b %errorlevel%
        )
    )
)

echo.
echo ===================================================================
echo All services built and pushed successfully!
echo ===================================================================
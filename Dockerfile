# ---- Build stage ----
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
# 若有測試太花時間，先跳過測試：-DskipTests
RUN mvn -U -B -DskipTests clean package

# ---- Run stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app
# 將 jar 名稱改成你實際打包後的檔名
COPY --from=build /app/target/*.jar /app/app.jar

# 設定容器內服務埠（與 Northflank 的公開埠對應）
ENV SERVER_PORT=8080
EXPOSE 8080

# 建議使用環境變數來帶 DB 與 magic-api 參數，避免把憑證寫進 image
ENTRYPOINT ["java","-Dserver.port=${SERVER_PORT}","-jar","/app/app.jar"]

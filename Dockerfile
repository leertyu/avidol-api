# Stage 1: Build stage
FROM rust:1.75-slim AS builder

WORKDIR /app

# 1. ติดตั้ง dependencies สำหรับการ compile (เช่น linker และ ssl)
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# 2. สร้างโครงร่างโปรเจกต์เพื่อทำ Layer Caching (ช่วยให้ build ครั้งต่อไปเร็วขึ้น)
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

# 3. คัดลอก Code จริงลงไปและ build ใหม่
COPY . .
RUN cargo build --release

# Stage 2: Run stage
FROM debian:bookworm-slim

# ติดตั้ง CA Certificates สำหรับการต่อฐานข้อมูลแบบปลอดภัย (TLS/SSL)
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# คัดลอกเฉพาะตัวไฟล์โปรแกรม (Binary) ที่ build เสร็จแล้วมาจาก Stage แรก
COPY --from=builder /app/target/release/avidol-api .

# คัดลอกไฟล์ .env (ถ้าต้องการใช้ใน container)
COPY .env .

# ระบุพอร์ตที่ API รัน
EXPOSE 8080

# คำสั่งสั่งรันโปรแกรม
CMD ["./avidol-api"]
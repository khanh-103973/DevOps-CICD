# Sử dụng Python 3.11
FROM python:3.11-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# Không tạo file .pyc và hiển thị log ngay
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Sao chép danh sách thư viện
COPY requirements.txt .

# Cài đặt thư viện Python
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép source code
COPY app.py .
COPY templates/ ./templates/

# Cổng ứng dụng Flask
EXPOSE 5000

# Khởi chạy ứng dụng
CMD ["python", "app.py"]
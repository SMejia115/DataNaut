# 📊 DataNaut: Data Analysis and Visualization Web Platform

## 🧠 Overview

**DataNaut** is an interactive web platform that enables users to upload structured data files (CSV, Excel, JSON), select relevant columns, perform basic statistical analysis, visualize data through various chart types, and build fully customizable dashboards in an intuitive way—no coding required.

---

## 🎯 Objectives

- Enable seamless upload, exploration, and visualization of datasets.
- Support exploratory data analysis (EDA) and column-wise correlations.
- Provide an intuitive and responsive interface to build interactive dashboards.
- Showcase fullstack development skills in a real-world scenario.
- Promote data-driven decision making through visual storytelling.

---

## 🛠️ Selected Technologies

| Component         | Technology                            |
|------------------|----------------------------------------|
| Frontend         | Angular + Angular Material + Chart.js / Plotly.js |
| Backend          | FastAPI (Python)                       |
| Data Processing  | Pandas, NumPy, Seaborn / Matplotlib    |
| API              | REST (JSON)                            |
| Database         | Pending                |
| Containerization | Docker                                 |

---

## 📋 Functional Requirements

1. Upload files in CSV, XLSX, or JSON formats.
2. Preview uploaded datasets in a tabular view.
3. Select columns for analysis.
4. Compute basic statistics (mean, median, std. dev, etc.).
5. Generate charts: bar, line, histogram, scatter, pie, etc.
6. Identify and visualize correlations between numerical columns.
7. Build and customize interactive dashboards.
8. Export dashboards as image or PDF.
9. *(Optional)* User authentication and dashboard persistence.

---

## 🚫 Non-Functional Requirements

- Intuitive and responsive user interface (mobile-friendly).
- Secure file upload with proper validation and sanitization.
- Efficient processing of medium-sized files (~50MB).
- Modular, clean, and maintainable codebase.
- Optimized frontend performance and loading speed.

---

## 📦 System Modules

| Module                  | Description                                             |
|-------------------------|---------------------------------------------------------|
| Data Upload             | File selection, upload, validation, and preview.        |
| Exploratory Analysis    | Column selection, descriptive stats, and summaries.     |
| Data Visualization      | Interactive and configurable chart generation.          |
| Dashboard Builder       | Area to create, arrange, and manage visual components.  |
| User Management (optional) | Registration, login, and dashboard persistence.     |

---

## 🧱 System Architecture

```text
[ User ]
   ↓
[ Frontend (Angular + TailwindCSS) ]
   ↕  (REST API - JSON)
[ Backend (FastAPI - Python) ]
   ↕
[ Data Analysis Engine (Pandas, NumPy, Matplotlib) ]
   ↕
[ Temporary File Storage / Database (Optional) ]

# 🚀 DevShow

### Your projects deserve more than a GitHub repository.

**DevShow** is a full-stack developer portfolio platform built to help developers showcase their work through beautiful profiles, detailed project pages, screenshots, technology stacks, GitHub repositories, and live demos.

🌐 **Web:** https://devshow.yashgaurkar.me  
📱 **Mobile:** Android app built with Flutter

---

## ✨ Features

### 👨‍💻 Developer Profiles
- Create a personalized developer profile
- Add bio, avatar, GitHub, LinkedIn, and website
- Share your profile with a public URL

### 🚀 Project Showcase
- Create and manage projects
- Add project descriptions with Markdown
- Showcase technology stacks
- Add GitHub repositories
- Add live demo links
- Upload up to 5 project screenshots
- Publish or unpublish projects

### 📱 Mobile Experience
- Android application built with Flutter
- Uses the same production backend as the web application
- Secure authentication
- Manage your profile and projects from your phone

### 🔐 Authentication
- User registration and login
- JWT-based authentication
- Secure password hashing with Argon2

---

## 🛠️ Tech Stack

### 🌐 Web
- React
- TypeScript
- Vite
- Tailwind CSS
- React Router
- Axios

### 📱 Mobile
- Flutter
- Dart

### ⚙️ Backend
- Python
- FastAPI
- SQLAlchemy
- PostgreSQL
- Alembic
- JWT
- Argon2

### ☁️ Deployment
- Vercel
- Azure VM
- Caddy
- HTTPS

---

## 🏗️ Architecture

```text
                    ┌──────────────────┐
                    │   DevShow Web    │
                    │ React + TS       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   FastAPI API    │
                    │ Python + JWT     │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   PostgreSQL     │
                    └──────────────────┘
                             ▲
                             │
                    ┌────────┴─────────┐
                    │  DevShow Mobile  │
                    │ Flutter + Dart   │
                    └──────────────────┘
```

One backend powers both the **web and Android applications**.

---

## 📸 Screenshots

### 🌐 Web Application

_Add web screenshots here._

### 📱 Android Application

_Add mobile screenshots here._

---

## 🔗 Links

🌐 **Live Web App**  
https://devshow.yashgaurkar.me

💻 **GitHub**  
https://github.com/yashG0/Devshow-application

---

## 🎯 Why I Built DevShow

I wanted a better way to present projects than simply listing repository links.

DevShow focuses on giving each project its own space — with screenshots, technical details, GitHub repositories, live demos, and a clean developer-focused presentation.

The project also evolved from a web application into a **multi-client platform**, with the Android application sharing the same backend.

---

## 🚧 Project Status

🟢 **Web:** Production  
🟢 **Backend:** Production  
🟡 **Android:** In development

More improvements are coming.

---

## 👨‍💻 Built By

**Yash Gaurkar**

MCA Student • Full Stack Developer

I enjoy building practical software across **backend APIs, databases, frontend applications, mobile development, and deployment**.

---

⭐ If you find DevShow interesting, consider giving the repository a star!

**Built. Shipped. Evolving. 🚀**

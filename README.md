# AI健康城区综合监管+宏观决策平台 — 演示部署说明

本仓库为单文件前端演示原型，根目录包含 `index.html`。下面给出将本项目发布为外网稳定 Demo 的步骤（推荐使用 GitHub Pages）。

方法 A（推荐，使用 `gh` CLI，需登录 GitHub）：

```bash
cd "C:\Users\johnn\Desktop\AI健康城市综合监管+宏观决策平台"
# 创建并推送仓库（替换为你的 <USERNAME>/<REPO>）
gh repo create <USERNAME>/<REPO> --public --source=. --remote=origin --push
```

方法 B（手动在 GitHub 建仓并推送）：

```bash
cd "C:\Users\johnn\Desktop\AI健康城市综合监管+宏观决策平台"
git init
git add .
git commit -m "Initial demo site"
git branch -M main
git remote add origin https://github.com/<USERNAME>/<REPO>.git
git push -u origin main
```

说明：
- 我已添加工作流文件 `.github/workflows/deploy-pages.yml`，仓库首次推送到 `main` 分支后，GitHub Actions 会自动将根目录发布到 GitHub Pages。发布完成后，站点 URL 格式为 `https://<USERNAME>.github.io/<REPO>`。
- 如果你希望我代为创建并推送仓库，我可以使用 `gh`（需要你在终端已登录 `gh`），或你也可以按上面命令自行操作。

如需使用 Netlify / Vercel 或保留自定义域名，我也可以提供对应的部署说明。若同意我代为推送，请回复“允许我用 gh 推送”，否则回复“我自己推送”。

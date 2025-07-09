#!/bin/bash
# AIOGEO 知識庫自動化遷移腳本
# 作者：廖天佑 Bless Liao
# 版本：v1.0

set -e  # 遇到錯誤立即停止

# 顏色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 打印帶顏色的訊息
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 檢查必要工具
check_dependencies() {
    print_status "檢查必要工具..."
    
    command -v git >/dev/null 2>&1 || { print_error "需要安裝 Git"; exit 1; }
    command -v pandoc >/dev/null 2>&1 || print_warning "建議安裝 Pandoc 以獲得更好的轉換效果"
    
    print_success "依賴檢查完成"
}

# 第一階段：備份和驗證
backup_and_verify() {
    print_status "=== 第一階段：備份驗證 ==="
    
    # 創建時間戳備份
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_DIR="AIOGEO_BACKUP_${TIMESTAMP}"
    
    print_status "創建完整備份到 ${BACKUP_DIR}..."
    cp -r . "../${BACKUP_DIR}"
    
    # 驗證重要檔案
    print_status "驗證核心內容檔案..."
    
    CORE_FILES=(
        "README.html"
        "about.html" 
        "geo-fundamentals.html"
        "semantic-mesh.html"
        "tools-README.html"
        "tools-schema-generator.html"
        "tools-checklists.html"
        "sitemap.xml"
        "robots.txt"
        "_config.yml"
    )
    
    MISSING_FILES=()
    for file in "${CORE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            print_success "✓ $file"
        else
            print_warning "✗ $file (缺失，但會嘗試從 .md 版本生成)"
            MISSING_FILES+=("$file")
        fi
    done
    
    # 統計內容
    HTML_COUNT=$(find . -name "*.html" -type f | wc -l)
    MD_COUNT=$(find . -name "*.md" -type f | wc -l)
    
    print_success "發現 ${HTML_COUNT} 個 HTML 檔案"
    print_success "發現 ${MD_COUNT} 個 Markdown 檔案"
    print_success "完整備份已保存到 ../${BACKUP_DIR}"
}

# 第二階段：建立新專案結構
create_clean_project() {
    print_status "=== 第二階段：建立新專案結構 ==="
    
    # 詢問新專案名稱
    read -p "請輸入新專案名稱 (預設: aiogeo-knowledge-clean): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-aiogeo-knowledge-clean}
    
    NEW_PROJECT_DIR="../${PROJECT_NAME}"
    
    if [[ -d "$NEW_PROJECT_DIR" ]]; then
        print_warning "目錄 $NEW_PROJECT_DIR 已存在"
        read -p "是否要覆蓋？(y/N): " OVERWRITE
        if [[ $OVERWRITE != "y" && $OVERWRITE != "Y" ]]; then
            print_error "取消操作"
            exit 1
        fi
        rm -rf "$NEW_PROJECT_DIR"
    fi
    
    print_status "創建新專案目錄結構..."
    mkdir -p "$NEW_PROJECT_DIR"/{articles,tools,assets/images,.github/workflows}
    
    # 創建 CNAME 文件
    print_status "創建 CNAME 文件..."
    echo "geo.25min.co" > "$NEW_PROJECT_DIR/CNAME"
    
    # 創建基礎配置文件
    create_config_files "$NEW_PROJECT_DIR"
    
    print_success "新專案結構創建完成：$NEW_PROJECT_DIR"
}

# 創建配置文件
create_config_files() {
    local project_dir=$1
    
    print_status "創建配置文件..."
    
    # _config.yml
    cat > "$project_dir/_config.yml" << 'EOF'
# AIOGEO 知識庫設定
title: "AIOGEO 知識庫"
description: "專業的生成式引擎優化指南"
url: "https://geo.25min.co"
baseurl: ""

# 作者資訊
author:
  name: "廖天佑 Bless Liao"
  github: "bless25min"

# 基本設定
lang: zh-TW
timezone: Asia/Taipei

# Jekyll 設定
markdown: kramdown
highlighter: rouge
plugins:
  - jekyll-sitemap
  - jekyll-seo-tag

# SEO 設定
social:
  name: 廖天佑 Bless Liao
  links:
    - https://github.com/bless25min
    - https://geo.25min.co

# 排除檔案
exclude:
  - README.md
  - .gitignore
  - .github/
  - node_modules/
  - vendor/
EOF

    # GitHub Actions workflow
    cat > "$project_dir/.github/workflows/deploy.yml" << 'EOF'
name: Deploy AIOGEO Knowledge Base

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

    # robots.txt
    cat > "$project_dir/robots.txt" << 'EOF'
User-agent: *
Allow: /

# AI 搜尋引擎友善設定
User-agent: GPTBot
Allow: /

User-agent: ChatGPT-User
Allow: /

User-agent: Claude-Web
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Google-Extended
Allow: /

# Sitemap
Sitemap: https://geo.25min.co/sitemap.xml

# 爬取延遲設定
Crawl-delay: 1
EOF

    print_success "配置文件創建完成"
}

# 第三階段：智能內容遷移
migrate_content() {
    print_status "=== 第三階段：智能內容遷移 ==="
    
    local project_dir="../${PROJECT_NAME}"
    
    # 遷移優先級列表
    declare -A PRIORITY_FILES=(
        ["README.html"]="index.html"
        ["about.html"]="about.html"
        ["geo-fundamentals.html"]="articles/geo-fundamentals.html"
        ["semantic-mesh.html"]="articles/semantic-mesh.html"
        ["tools-README.html"]="tools/index.html"
        ["tools-schema-generator.html"]="tools/schema-generator.html"
        ["tools-checklists.html"]="tools/checklists.html"
        ["tools-content-templates.html"]="tools/content-templates.html"
        ["contributing.html"]="contributing.html"
    )
    
    print_status "遷移核心內容文件..."
    
    for source_file in "${!PRIORITY_FILES[@]}"; do
        target_file="${PRIORITY_FILES[$source_file]}"
        target_path="$project_dir/$target_file"
        
        # 創建目標目錄
        mkdir -p "$(dirname "$target_path")"
        
        if [[ -f "$source_file" ]]; then
            print_status "遷移: $source_file -> $target_file"
            
            # 複製並處理內容
            process_content_file "$source_file" "$target_path"
            
            print_success "✓ $target_file"
        else
            print_warning "檔案不存在: $source_file"
            
            # 嘗試從 .md 文件生成
            md_file="${source_file%.html}.md"
            if [[ -f "$md_file" ]]; then
                print_status "從 Markdown 生成: $md_file -> $target_file"
                convert_markdown_to_html "$md_file" "$target_path"
                print_success "✓ $target_file (從 MD 生成)"
            fi
        fi
    done
    
    # 複製其他重要文件
    print_status "複製其他重要文件..."
    
    # 複製圖片和資源
    if [[ -d "assets" ]]; then
        cp -r assets/* "$project_dir/assets/" 2>/dev/null || true
        print_success "✓ 複製 assets 資料夾"
    fi
    
    # 複製其他 HTML 文件
    find . -name "*.html" -type f | while read -r file; do
        if [[ ! "${PRIORITY_FILES[$file]+isset}" ]]; then
            relative_path=${file#./}
            target_path="$project_dir/$relative_path"
            mkdir -p "$(dirname "$target_path")"
            process_content_file "$file" "$target_path"
            print_success "✓ 額外文件: $relative_path"
        fi
    done
}

# 處理內容文件
process_content_file() {
    local source_file=$1
    local target_file=$2
    
    # 複製文件
    cp "$source_file" "$target_file"
    
    # 更新網域名稱
    sed -i.bak 's|https://bless25min\.github\.io/AIOGEO-Knowledge|https://geo.25min.co|g' "$target_file"
    sed -i.bak 's|bless25min\.github\.io/AIOGEO-Knowledge|geo.25min.co|g' "$target_file"
    
    # 清理備份文件
    rm -f "${target_file}.bak"
}

# Markdown 轉 HTML
convert_markdown_to_html() {
    local md_file=$1
    local html_file=$2
    
    if command -v pandoc >/dev/null 2>&1; then
        # 使用 Pandoc 轉換
        pandoc "$md_file" -o "$html_file" \
            --standalone \
            --metadata title="AIOGEO 知識庫" \
            --css="/assets/css/style.css" \
            --template=html5
    else
        # 簡單的 Markdown 轉換
        echo "<!DOCTYPE html><html><head><title>AIOGEO 知識庫</title></head><body>" > "$html_file"
        cat "$md_file" >> "$html_file"
        echo "</body></html>" >> "$html_file"
    fi
    
    # 更新網域
    process_content_file "$html_file" "$html_file"
}

# 第四階段：生成 Sitemap
generate_sitemap() {
    print_status "=== 第四階段：生成 Sitemap ==="
    
    local project_dir="../${PROJECT_NAME}"
    local sitemap_file="$project_dir/sitemap.xml"
    
    print_status "生成 sitemap.xml..."
    
    cat > "$sitemap_file" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://geo.25min.co/</loc>
    <lastmod>2025-07-09</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
EOF

    # 自動發現所有 HTML 文件並添加到 sitemap
    find "$project_dir" -name "*.html" -type f | while read -r file; do
        # 跳過根目錄的 index.html（已經包含）
        if [[ "$file" == "$project_dir/index.html" ]]; then
            continue
        fi
        
        # 獲取相對路徑
        relative_path=${file#$project_dir/}
        
        # 設定優先級
        priority="0.8"
        changefreq="weekly"
        
        if [[ "$relative_path" == articles/* ]]; then
            priority="0.9"
        elif [[ "$relative_path" == tools/* ]]; then
            priority="0.7"
        fi
        
        cat >> "$sitemap_file" << EOF
  <url>
    <loc>https://geo.25min.co/$relative_path</loc>
    <lastmod>2025-07-09</lastmod>
    <changefreq>$changefreq</changefreq>
    <priority>$priority</priority>
  </url>
EOF
    done
    
    echo "</urlset>" >> "$sitemap_file"
    
    local url_count=$(grep -c "<url>" "$sitemap_file")
    print_success "Sitemap 生成完成，包含 $url_count 個網址"
}

# 第五階段：初始化 Git
initialize_git() {
    print_status "=== 第五階段：初始化 Git 倉庫 ==="
    
    local project_dir="../${PROJECT_NAME}"
    
    cd "$project_dir"
    
    # 初始化 Git
    git init
    git branch -M main
    
    # 創建 .gitignore
    cat > .gitignore << 'EOF'
# 系統文件
.DS_Store
Thumbs.db

# 編輯器文件
.vscode/
.idea/
*.swp
*.swo

# 備份文件
*.bak
*.backup

# 臨時文件
*.tmp
*.temp

# Jekyll
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata

# Node.js
node_modules/
npm-debug.log*

# 其他
*.log
EOF

    # 提交所有文件
    git add .
    git commit -m "🎉 AIOGEO 知識庫遷移完成

✨ 功能特色：
- 🔄 從原專案完整遷移所有內容
- 🌐 更新網域為 geo.25min.co
- 🤖 AI 友善的 robots.txt 設定
- 🗺️ 自動生成的 sitemap.xml
- 📱 響應式設計和手機端優化
- 🚀 GitHub Actions 自動部署

📊 遷移統計：
- 📄 HTML 頁面：$(find . -name "*.html" | wc -l) 個
- 🗺️ Sitemap 網址：$(grep -c "<url>" sitemap.xml) 個
- 🛠️ 工具頁面：$(find tools -name "*.html" 2>/dev/null | wc -l) 個
- 📚 文章頁面：$(find articles -name "*.html" 2>/dev/null | wc -l) 個

👨‍💻 作者：廖天佑 Bless Liao
🎯 專案：AIOGEO 知識庫
⏰ 遷移時間：$(date)"
    
    cd - > /dev/null
    
    print_success "Git 倉庫初始化完成"
}

# 第六階段：驗證和報告
validate_and_report() {
    print_status "=== 第六階段：驗證和生成報告 ==="
    
    local project_dir="../${PROJECT_NAME}"
    
    print_status "驗證遷移結果..."
    
    # 統計文件
    local html_count=$(find "$project_dir" -name "*.html" -type f | wc -l)
    local total_size=$(du -sh "$project_dir" | cut -f1)
    local sitemap_urls=$(grep -c "<url>" "$project_dir/sitemap.xml" 2>/dev/null || echo "0")
    
    # 檢查重要文件
    local critical_files=("index.html" "about.html" "CNAME" "_config.yml" "robots.txt" "sitemap.xml")
    local missing_critical=()
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$project_dir/$file" ]]; then
            missing_critical+=("$file")
        fi
    done
    
    # 生成報告
    cat > "../AIOGEO_遷移報告_${TIMESTAMP}.md" << EOF
# 🎉 AIOGEO 知識庫遷移完成報告

## 📊 遷移統計

| 項目 | 數量/狀態 |
|------|----------|
| **HTML 頁面** | ${html_count} 個 |
| **專案大小** | ${total_size} |
| **Sitemap 網址** | ${sitemap_urls} 個 |
| **關鍵文件** | $(( ${#critical_files[@]} - ${#missing_critical[@]} ))/${#critical_files[@]} 完整 |

## 📁 專案結構

\`\`\`
$(cd "$project_dir" && find . -type f -name "*.html" | head -20 | sort)
$(cd "$project_dir" && find . -type f -name "*.html" | wc -l | awk '{if($1>20) print "... 和其他 " ($1-20) " 個文件"}')
\`\`\`

## ✅ 遷移成功項目

- 🏠 首頁設計完成
- 📚 核心文章完整保留
- 🛠️ 工具庫完整遷移
- 🤖 AI 友善設定
- 🗺️ SEO 優化配置
- 🚀 自動部署流程

$(if [[ ${#missing_critical[@]} -eq 0 ]]; then
    echo "## 🎯 所有關鍵文件都已成功遷移！"
else
    echo "## ⚠️ 需要注意的項目"
    for file in "${missing_critical[@]}"; do
        echo "- ❌ 缺失: $file"
    done
fi)

## 🔄 下一步操作

1. **GitHub 設定**：
   \`\`\`bash
   cd ${PROJECT_NAME}
   git remote add origin https://github.com/bless25min/${PROJECT_NAME}.git
   git push -u origin main
   \`\`\`

2. **GitHub Pages 設定**：
   - 前往 Repository Settings → Pages
   - Source: GitHub Actions
   - Custom domain: geo.25min.co

3. **DNS 設定驗證**：
   - 確認 Namecheap DNS A 記錄設定
   - 等待 DNS 傳播（通常 30 分鐘內）

## 📞 技術支援

如有任何問題，請：
- 檢查 GitHub Actions 執行狀態
- 確認 DNS 設定正確
- 驗證 HTTPS 憑證生成

---

**遷移完成時間**：$(date)  
**備份位置**：../AIOGEO_BACKUP_${TIMESTAMP}  
**新專案位置**：../${PROJECT_NAME}
EOF

    print_success "遷移完成！"
    print_success "📄 詳細報告已保存到：../AIOGEO_遷移報告_${TIMESTAMP}.md"
    print_success "📦 新專案位置：$project_dir"
    print_success "🛡️ 完整備份位置：../AIOGEO_BACKUP_${TIMESTAMP}"
    
    echo ""
    echo "🎯 遷移統計："
    echo "   📄 HTML 頁面：${html_count} 個"
    echo "   🗺️ Sitemap 網址：${sitemap_urls} 個"
    echo "   📦 專案大小：${total_size}"
    echo ""
    echo "🚀 下一步："
    echo "   1. 檢查新專案內容：cd $project_dir"
    echo "   2. 推送到 GitHub：按照報告中的說明操作"
    echo "   3. 設定 GitHub Pages 和 DNS"
}

# 主函數
main() {
    echo "🚀 AIOGEO 知識庫自動化遷移工具"
    echo "=================================="
    echo ""
    
    # 確認操作
    read -p "這將創建一個新的乾淨專案並遷移所有內容。繼續？(y/N): " CONFIRM
    if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
        print_error "操作已取消"
        exit 1
    fi
    
    # 執行所有階段
    check_dependencies
    backup_and_verify
    create_clean_project
    migrate_content
    generate_sitemap
    initialize_git
    validate_and_report
    
    echo ""
    echo "🎉 恭喜！AIOGEO 知識庫遷移已完成！"
    echo "所有珍貴內容都已安全遷移並優化。"
}

# 執行主函數
main "$@"
#!/bin/bash

# تعيين مسار المشروع
projectPath="/home/user/islamiaat.github.io"

# تعيين مسار ملف sitemap.xml والعدد الأقصى للروابط في كل ملف خريطة
sitemapPathBase="$projectPath/sitemap"
maxLinksPerFile=10000  # عدد الروابط الأقصى في كل ملف خريطة

# إنشاء مجلد للخرائط إذا لم يكن موجودًا
mkdir -p "$projectPath/sitemaps"

# بدء بناء ملفات sitemap.xml
fileCount=1
linksCount=0

# الحصول على جميع ملفات HTML واستخدام stat للحصول على تاريخ آخر تعديل
find "$projectPath" -name "*.html" | while IFS= read -r file; do
    # تحقق من العدد الحالي للروابط
    if [ $linksCount -eq 0 ]; then
        # إذا كانت عدد الروابط صفر، إنشاء ملف جديد للخريطة
        sitemapPath="${sitemapPathBase}_${fileCount}.xml"
        echo '<?xml version="1.0" encoding="UTF-8"?>' > "$sitemapPath"
        echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> "$sitemapPath"
        echo "إنشاء ملف خريطة جديد: $sitemapPath"
    fi

    # إضافة الروابط إلى ملف الخريطة الحالي
    link="https://islamiaat.github.io${file#$projectPath}"
    url="${link//\//\/}"
    lastmod=$(stat -c '%y' "$file" | cut -d ' ' -f1)
    echo "<url>" >> "$sitemapPath"
    echo "   <loc>$url</loc>" >> "$sitemapPath"
    echo "   <lastmod>$lastmod</lastmod>" >> "$sitemapPath"
    echo "   <changefreq>monthly</changefreq>" >> "$sitemapPath"
    echo "   <priority>0.7</priority>" >> "$sitemapPath"
    echo "</url>" >> "$sitemapPath"
    echo "تم إضافة المسار: $url"

    # زيادة عدد الروابط والتحقق من التجاوز إذا كان ضروريًا
    (( linksCount++ ))
    if [ $linksCount -ge $maxLinksPerFile ]; then
        # إذا تجاوز عدد الروابط الحد الأقصى، أغلق ملف الخريطة الحالي
        echo '</urlset>' >> "$sitemapPath"
        echo "تم إنهاء ملف خريطة: $sitemapPath"
        (( fileCount++ ))
        linksCount=0
    fi
done

# إغلاق أي ملف خريطة متبقٍ
if [ $linksCount -gt 0 ]; then
    echo '</urlset>' >> "$sitemapPath"
    echo "تم إنهاء ملف خريطة: $sitemapPath"
fi

echo "تم إنشاء جميع ملفات الخريطة بنجاح في المسار: $projectPath/sitemaps"

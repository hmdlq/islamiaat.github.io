@echo off
setlocal enabledelayedexpansion

REM تعيين مسار المشروع
set "projectPath=C:\Users\hp\islamiaat.github.io"

REM تعيين مسار مجلد الخرائط
set "sitemapFolder=%projectPath%\sitemaps"

REM إنشاء مجلد للخرائط إذا لم يكن موجودًا
if not exist "%sitemapFolder%" mkdir "%sitemapFolder%"

REM تعيين العدد الأقصى للروابط في كل ملف خريطة
set "maxLinksPerFile=1000"

REM بدء بناء ملفات sitemap.xml
set "fileCount=1"
set "linksCount=0"

REM الحصول على جميع ملفات HTML واستخدام تاريخ آخر تعديل
for /r "%projectPath%" %%f in (*.html) do (
    REM تحقق من العدد الحالي للروابط
    if !linksCount! equ 0 (
        REM إنشاء ملف خريطة جديد
        set "sitemapPath=%sitemapFolder%\sitemap_!fileCount!.xml"
        echo ^<?xml version="1.0" encoding="UTF-8"?^> > "!sitemapPath!"
        echo ^<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"^> >> "!sitemapPath!"
        echo إنشاء ملف خريطة جديد: "!sitemapPath!"
    )

    REM إضافة الروابط إلى ملف الخريطة الحالي
    set "file=%%f"
    set "link=https://islamiaat.github.io!file:%projectPath%=!"
    set "url=!link:\=/%!"
    for /f %%i in ('powershell -command "(Get-Item '%%f').LastWriteTime.ToString('yyyy-MM-dd')"') do set "lastmod=%%i"

    REM التعامل مع الحالة التي تحتوي على "+"
    if "!lastmod!" equ "+" set "lastmod=2024-06-03"

    echo ^<url^> >> "!sitemapPath!"
    echo    ^<loc^>!url!^</loc^> >> "!sitemapPath!"
    echo    ^<lastmod^>!lastmod!^</lastmod^> >> "!sitemapPath!"
    echo    ^<changefreq^>monthly^</changefreq^> >> "!sitemapPath!"
    echo    ^<priority^>0.7^</priority^> >> "!sitemapPath!"
    echo ^</url^> >> "!sitemapPath!"
    echo تم إضافة المسار: !url!

    REM زيادة عدد الروابط والتحقق من التجاوز إذا كان ضروريًا
    set /a linksCount+=1
    if !linksCount! geq %maxLinksPerFile% (
        REM إذا تجاوز عدد الروابط الحد الأقصى، أغلق ملف الخريطة الحالي
        echo ^</urlset^> >> "!sitemapPath!"
        echo تم إنهاء ملف خريطة: "!sitemapPath!"
        set /a fileCount+=1
        set "linksCount=0"
    )
)

REM إغلاق ملفات الخريطة المتبقية
if !linksCount! gtr 0 (
    echo ^</urlset^> >> "!sitemapPath!"
    echo تم إنهاء ملف خريطة: "!sitemapPath!"
)

echo تم إنشاء جميع ملفات الخريطة بنجاح في المسار: %sitemapFolder%

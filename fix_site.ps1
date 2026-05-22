$file = "c:\Users\M.L.Store\Downloads\promot\index.html"
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# ─────────────────────────────────────────────────────────────
# FIX 1: Replace the "Latest Articles" section.
#   Remove duplicate Obesity & CBC cards.
#   Keep only the Healthy Nutrition card and add a "View All" link to Nutrition Science.
# ─────────────────────────────────────────────────────────────
$oldArticles = @'
<!-- ===== LATEST ARTICLES SECTION ===== -->
<section class="articles" id="articles">

    <h2 id="articles-title" data-en="Latest Articles" data-ar="آخر المقالات">Latest Articles</h2>

    <div class="articles-container">

        <div class="card">
            <img src="obesity.jpg" alt="Obesity" onerror="this.src='https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&q=80'">
            <h3 id="card1-title" data-en="Understanding Obesity" data-ar="فهم السمنة">Understanding Obesity</h3>
            <p id="card1-desc" data-en="Learn the scientific causes of obesity and healthy ways to manage it." data-ar="تعرف على الأسباب العلمية للسمنة وطرق التحكم بها صحياً.">
                Learn the scientific causes of obesity and healthy ways to manage it.
            </p>
            <a href="javascript:void(0)" onclick="openArticle('obesity')" class="read-more-btn" data-en="Read More" data-ar="اقرأ المزيد">Read More</a>
        </div>

        <div class="card">
            <img src="cbc.jpg" alt="CBC Test" onerror="this.src='https://images.unsplash.com/photo-1579154204601-01588f351e67?w=600&q=80'">
            <h3 id="card2-title" data-en="Complete Blood Count (CBC)" data-ar="تعداد الدم الكامل (CBC)">Complete Blood Count (CBC)</h3>
            <p id="card2-desc" data-en="Learn about CBC components, normal ranges, and clinical result analysis." data-ar="تعرف على مكونات فحص CBC، المعدلات الطبيعية، وتفسير النتائج السريرية.">
                Learn about CBC components, normal ranges, and clinical result analysis.
            </p>
            <a href="javascript:void(0)" onclick="openArticle('cbc')" class="read-more-btn" data-en="Read More" data-ar="اقرأ المزيد">Read More</a>
        </div>

        <div class="card">
            <img src="nutrition.jpg" alt="Nutrition" onerror="this.src='https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80'">
            <h3 id="card3-title" data-en="Healthy Nutrition" data-ar="التغذية الصحية">Healthy Nutrition</h3>
            <p id="card3-desc" data-en="Balanced nutrition improves energy and overall health." data-ar="التغذية المتوازنة تساعد على تحسين الصحة والطاقة.">
                Balanced nutrition improves energy and overall health.
            </p>
            <a href="#" class="read-more-btn" data-en="Read More" data-ar="اقرأ المزيد">Read More</a>
        </div>

    </div>

</section>
'@

$newArticles = @'
<!-- ===== LATEST ARTICLES SECTION ===== -->
<section class="articles" id="articles">

    <h2 id="articles-title" data-en="Latest Articles" data-ar="آخر المقالات">Latest Articles</h2>

    <div class="articles-container">

        <div class="card">
            <img src="obesity.jpg" alt="Obesity" onerror="this.src='https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&q=80'">
            <h3 id="card1-title" data-en="Understanding Obesity" data-ar="فهم السمنة">Understanding Obesity</h3>
            <p id="card1-desc" data-en="Learn the scientific causes of obesity and healthy ways to manage it." data-ar="تعرف على الأسباب العلمية للسمنة وطرق التحكم بها صحياً.">
                Learn the scientific causes of obesity and healthy ways to manage it.
            </p>
            <a href="javascript:void(0)" onclick="openArticle('obesity')" class="read-more-btn" data-en="Read More" data-ar="اقرأ المزيد">Read More</a>
        </div>

        <div class="card">
            <img src="cbc.jpg" alt="CBC Test" onerror="this.src='https://images.unsplash.com/photo-1579154204601-01588f351e67?w=600&q=80'">
            <h3 id="card2-title" data-en="Complete Blood Count (CBC)" data-ar="تعداد الدم الكامل (CBC)">Complete Blood Count (CBC)</h3>
            <p id="card2-desc" data-en="Learn about CBC components, normal ranges, and clinical result analysis." data-ar="تعرف على مكونات فحص CBC، المعدلات الطبيعية، وتفسير النتائج السريرية.">
                Learn about CBC components, normal ranges, and clinical result analysis.
            </p>
            <a href="javascript:void(0)" onclick="openArticle('cbc')" class="read-more-btn" data-en="Read More" data-ar="اقرأ المزيد">Read More</a>
        </div>

        <div class="card">
            <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80" alt="Nutrition">
            <h3 id="card3-title" data-en="Healthy Nutrition" data-ar="التغذية الصحية">Healthy Nutrition</h3>
            <p id="card3-desc" data-en="Balanced nutrition improves energy, boosts immunity, and supports a healthy lifestyle." data-ar="التغذية المتوازنة تساعد على تحسين الطاقة وتعزيز المناعة ودعم نمط الحياة الصحي.">
                Balanced nutrition improves energy, boosts immunity, and supports a healthy lifestyle.
            </p>
            <a href="#nutrition" class="read-more-btn" data-en="Explore Topics" data-ar="استكشف المواضيع">Explore Topics</a>
        </div>

    </div>

</section>
'@

# ─────────────────────────────────────────────────────────────
# FIX 2: Replace the corrupted CBC article panel opening (lines 1867-1902).
#   The broken tag + duplicate table rows need to become the proper panel header.
# ─────────────────────────────────────────────────────────────

# The corrupted block starts after the obesity panel end comment and goes to line 1902's trailing junk.
# We identify it by the unique broken string.
$oldCbcPanel = @'
<!-- ARTICLE PANEL (hidden by default) -->
<div class="article-pane'@

# We need to find the exact corrupted start. Let's use a different anchor.
# The corruption runs from the broken div tag all the way up to the line ending 
# with the garbled text before "<!-- Components Section -->"
# We anchor on what comes right before it (end of obesity panel) and after (Components Section).

$oldCbcCorrupt = '<!-- ARTICLE PANEL (hidden by default) -->
<div class="article-pane'

$newCbcStart = '<!-- ARTICLE PANEL: CBC (hidden by default) -->
<div class="article-panel" id="panel-cbc">

  <button class="panel-back-btn" onclick="closeArticle(''cbc'')">&#8592; <span id="back-btn-cbc" data-en="Back to Articles" data-ar="العودة إلى المقالات">Back to Articles</span></button>

  <article class="article-card" itemscope itemtype="https://schema.org/MedicalWebPage">

  <img
    class="article-cover"
    src="https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=1200&auto=format&fit=crop"
    alt="Complete Blood Count CBC – Znar F. Edo"
    loading="lazy"
  >

  <div class="article-body">

    <span class="article-tag" id="cbc-tag" data-en="&#129514; Laboratory Analysis" data-ar="&#129514; التحليلات المرضية">&#129514; Laboratory Analysis</span>

    <h1 class="article-title-main" itemprop="name">Complete Blood Count (CBC)</h1>

    <p class="article-meta" id="cbc-meta"
       data-en="&#128197; Published: May 2026 &amp;nbsp;|&amp;nbsp; &#9997;&#65039; Znar F. Edo &amp;nbsp;|&amp;nbsp; &#127757; Bilingual Article (EN / AR)"
       data-ar="&#128197; تاريخ النشر: مايو 2026 &amp;nbsp;|&amp;nbsp; &#9997;&#65039; زنار ف. إيدو &amp;nbsp;|&amp;nbsp; &#127757; مقال ثنائي اللغة">
      &#128197; Published: May 2026 &nbsp;|&nbsp; &#9997;&#65039; Znar F. Edo &nbsp;|&nbsp; &#127757; Bilingual Article (EN / AR)
    </p>

    <p class="article-intro-text" id="cbc-intro" itemprop="description"
       data-en="A Complete Blood Count (CBC) evaluates the cellular elements of blood. The test is performable within minutes using automated hematology analyzers, measuring the concentration, size, and distribution of different cell lines in the circulatory system."
       data-ar="فحص تعداد الدم الكامل (CBC) يُقيّم العناصر الخلوية للدم. يمكن إجراؤه في دقائق باستخدام أجهزة تحليل أمراض الدم الآلية، حيث يقيس تركيز وحجم وتوزيع سلالات الخلايا المختلفة في الدورة الدموية.">
      A Complete Blood Count (CBC) evaluates the cellular elements of blood. The test is performable within minutes using automated hematology analyzers, measuring the concentration, size, and distribution of different cell lines in the circulatory system.
    </p>'

Write-Host "Reading file..."
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
Write-Host "File size: $($content.Length) bytes"

# ── Fix 1: Update Latest Articles section ──────────────────────────────────────
if ($content.Contains($oldArticles)) {
    $content = $content.Replace($oldArticles, $newArticles)
    Write-Host "Fix 1 APPLIED: Latest Articles section updated."
} else {
    Write-Host "Fix 1 SKIPPED: Could not find exact Latest Articles block."
}

# ── Fix 2: Repair the broken CBC panel ─────────────────────────────────────────
# Find the corrupted section between end of obesity panel and Components Section comment
$searchStart = '</div><!-- end article-panel -->'  + "`r`n`r`n<!-- ARTICLE PANEL (hidden by default) -->"
$searchEnd = "`r`n`r`n    <!-- Components Section -->"

$startIdx = $content.IndexOf($searchStart)
$endIdx   = $content.IndexOf($searchEnd)

if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
    $beforeFix = $content.Substring(0, $startIdx + $searchStart.Length)
    $afterFix  = $content.Substring($endIdx)  # keeps from <!-- Components Section --> onward
    
    $fixedCbc = "`r`n`r`n<!-- ARTICLE PANEL: CBC (hidden by default) -->`r`n<div class=`"article-panel`" id=`"panel-cbc`">`r`n`r`n  <button class=`"panel-back-btn`" onclick=`"closeArticle('cbc')`">&#8592; <span id=`"back-btn-cbc`" data-en=`"Back to Articles`" data-ar=`"العودة إلى المقالات`">Back to Articles</span></button>`r`n`r`n  <article class=`"article-card`" itemscope itemtype=`"https://schema.org/MedicalWebPage`">`r`n`r`n  <img`r`n    class=`"article-cover`"`r`n    src=`"https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=1200&auto=format&fit=crop`"`r`n    alt=`"Complete Blood Count CBC - Znar F. Edo`"`r`n    loading=`"lazy`"`r`n  >`r`n`r`n  <div class=`"article-body`">`r`n`r`n    <span class=`"article-tag`" id=`"cbc-tag`" data-en=`"&#129514; Laboratory Analysis`" data-ar=`"&#129514; التحليلات المرضية`">&#129514; Laboratory Analysis</span>`r`n`r`n    <h1 class=`"article-title-main`" itemprop=`"name`">Complete Blood Count (CBC)</h1>`r`n`r`n    <p class=`"article-meta`" id=`"cbc-meta`"`r`n       data-en=`"&#128197; Published: May 2026 &amp;nbsp;|&amp;nbsp; &#9997;&#65039; Znar F. Edo &amp;nbsp;|&amp;nbsp; &#127757; Bilingual Article (EN / AR)`"`r`n       data-ar=`"&#128197; تاريخ النشر: مايو 2026 &amp;nbsp;|&amp;nbsp; &#9997;&#65039; زنار ف. إيدو &amp;nbsp;|&amp;nbsp; &#127757; مقال ثنائي اللغة`">`r`n      &#128197; Published: May 2026 &nbsp;|&nbsp; &#9997;&#65039; Znar F. Edo &nbsp;|&nbsp; &#127757; Bilingual Article (EN / AR)`r`n    </p>`r`n`r`n    <p class=`"article-intro-text`" id=`"cbc-intro`" itemprop=`"description`"`r`n       data-en=`"A Complete Blood Count (CBC) evaluates the cellular elements of blood. The test is performable within minutes using automated hematology analyzers, measuring the concentration, size, and distribution of different cell lines in the circulatory system.`"`r`n       data-ar=`"فحص تعداد الدم الكامل (CBC) يُقيّم العناصر الخلوية للدم. يمكن إجراؤه في دقائق باستخدام أجهزة تحليل أمراض الدم الآلية، حيث يقيس تركيز وحجم وتوزيع سلالات الخلايا المختلفة في الدورة الدموية.`">`r`n      A Complete Blood Count (CBC) evaluates the cellular elements of blood. The test is performable within minutes using automated hematology analyzers, measuring the concentration, size, and distribution of different cell lines in the circulatory system.`r`n    </p>`r`n"
    
    $content = $beforeFix + $fixedCbc + $afterFix
    Write-Host "Fix 2 APPLIED: Corrupted CBC panel opening repaired."
} else {
    Write-Host "Fix 2 SKIPPED: Could not locate exact boundaries. startIdx=$startIdx endIdx=$endIdx"
    # Fallback: show what we found
    if ($startIdx -ge 0) { Write-Host "  startIdx found at $startIdx" }
    if ($endIdx -ge 0)   { Write-Host "  endIdx   found at $endIdx" }
}

# ── Save file ─────────────────────────────────────────────────
[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "File saved successfully."

import sys

file_path = 'c:/Users/M.L.Store/Downloads/promot/index.html'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Replace the card link
old_link = '<a href="javascript:void(0)" onclick="openArticle(\'obesity\')" class="read-more-btn">Read More</a>'
new_link = '<a href="#understanding-obesity" class="read-more-btn">Read More</a>'
content = content.replace(old_link, new_link)

# 2. Replace the #nutrition section
start_marker = '<!-- ===== NUTRITION SCIENCE SECTION ===== -->'
end_marker = '<!-- ===== END NUTRITION SCIENCE ===== -->'
start_idx = content.find(start_marker)
end_idx = content.find(end_marker) + len(end_marker)

if start_idx != -1 and end_idx != -1:
    new_section = '''<!-- =============================== -->
<!-- UNDERSTANDING OBESITY SECTION -->
<!-- =============================== -->

<section id="understanding-obesity" class="section">

  <div class="container">

    <h2 class="section-title">Understanding Obesity</h2>

    <p class="section-subtitle">
      Scientific and medical explanation of obesity (bilingual article EN / AR)
    </p>

    <!-- ARTICLE START -->
    <article class="article-card">

      <h1>Obesity (السمنة)</h1>

      <p>
        🗓 Published: May 2026 | ✍️ Znar F. Edo | 🌍 Bilingual Article (EN / AR)
      </p>

      <p>
        Obesity is a chronic medical condition characterized by excessive accumulation of body fat to a degree that negatively affects health. It is associated with increased risk of metabolic disorders, cardiovascular diseases, type 2 diabetes, hypertension, and several forms of cancer. The World Health Organization classifies obesity as one of the most significant global health challenges.
      </p>

      <h3>نظرة عامة — Overview</h3>
      <p>
        السمنة هي حالة مرضية مزمنة تتميز بتراكم الدهون في الجسم بشكل مفرط إلى درجة تؤثر سلبًا على الصحة العامة...
      </p>

      <h3>What is Obesity?</h3>
      <p>
        Obesity occurs when energy intake consistently exceeds energy expenditure...
      </p>

      <h3>📐 Body Mass Index (BMI) Formula</h3>

      <p><b>BMI = Weight (kg) ÷ Height² (m²)</b></p>

      <ul>
        <li><b>&lt; 18.5</b> — Underweight / نقص وزن</li>
        <li><b>18.5 – 24.9</b> — Normal Weight / وزن طبيعي</li>
        <li><b>25 – 29.9</b> — Overweight / زيادة وزن</li>
        <li><b>30 – 39.9</b> — Obesity / سمنة</li>
        <li><b>≥ 40</b> — Severe Obesity / سمنة مفرطة</li>
      </ul>

      <h3>Is Obesity a Disease?</h3>
      <p>
        Yes. Obesity is recognized as a chronic, multifactorial disease...
      </p>

      <h3>Main Causes of Obesity</h3>
      <ol>
        <li>Excessive Calorie Intake</li>
        <li>Physical Inactivity</li>
        <li>Genetic Factors</li>
        <li>Hormonal Disorders</li>
        <li>Sleep Deprivation</li>
        <li>Psychological Factors</li>
        <li>Medications</li>
      </ol>

      <h3>Role of Hormones in Obesity</h3>
      <p>
        Insulin, Leptin, Ghrelin, Cortisol, Thyroid hormones...
      </p>

      <h3>Health Risks of Obesity</h3>
      <p>
        Diabetes, Heart disease, Hypertension, Dyslipidemia, Sleep apnea...
      </p>

      <h3>Management & Treatment</h3>
      <ul>
        <li>Nutritional therapy</li>
        <li>Physical exercise</li>
        <li>Behavioral modification</li>
        <li>Pharmacological treatment</li>
        <li>Bariatric surgery</li>
      </ul>

      <h3>Conclusion — الخلاصة</h3>
      <p>
        Obesity is a multifactorial chronic disease...
      </p>

      <h3>📚 References</h3>
      <ul>
        <li>WHO — Obesity and Overweight</li>
        <li>CDC — Obesity</li>
        <li>NIDDK</li>
      </ul>

    </article>
    <!-- ARTICLE END -->

  </div>

</section>'''
    content = content[:start_idx] + new_section + content[end_idx:]

# 3. Remove openArticle and closeArticle functions
start_js_marker = 'function openArticle(id){'
end_js_marker = "  document.getElementById('nutrition').scrollIntoView({behavior:'smooth',block:'start'});\n}"

start_js_idx = content.find(start_js_marker)
end_js_idx = content.find(end_js_marker) + len(end_js_marker)

if start_js_idx != -1 and end_js_idx != -1:
    content = content[:start_js_idx] + content[end_js_idx:]

# 4. Remove T translations and translateAll
start_t = '/* ── Bilingual translations for Nutrition Science section ── */'
end_t = '  });\n}\n\n'
start_t_idx = content.find(start_t)
end_t_idx = content.find(end_t, start_t_idx) + len(end_t)

if start_t_idx != -1 and end_t_idx != -1:
    content = content[:start_t_idx] + content[end_t_idx:]

# 5. Remove translateAll() calls in toggleLanguage
content = content.replace('    translateAll(\'ar\');\n', '')
content = content.replace('    translateAll(\'en\');\n', '')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Replacements applied successfully.')
